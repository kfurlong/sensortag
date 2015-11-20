/*
 * Copyright (c) 2015, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdint.h>
#include <xdc/runtime/Error.h>
#include <xdc/runtime/Assert.h>
#include <xdc/runtime/Diags.h>
#include <xdc/runtime/Log.h>
#include <xdc/runtime/System.h>
#include <xdc/runtime/Types.h>

#include <ti/drivers/spi/SPITivaDMA.h>

#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/knl/Semaphore.h>
#include <ti/sysbios/family/arm/m3/Hwi.h>

/* driverlib header files */
#include <inc/hw_memmap.h>
#include <inc/hw_types.h>
#include <inc/hw_ssi.h>
#include <driverlib/ssi.h>
#include <driverlib/udma.h>
#include <driverlib/sysctl.h>

/*
 * Macro to access "Mode of Operation" bits in the SSIPP register
 * If it returns 0; we're using a SSI controller
 * else, we're using a Bi-/Quad-SSI peripheral
 */
#define SSIMODE(baseAddr) HWREG(baseAddr + SSI_O_PP) & (SSI_PP_MODE_M)

/* SPITiva functions */
void         SPITivaDMA_close(SPI_Handle handle);
int          SPITivaDMA_control(SPI_Handle handle, unsigned int cmd, void *arg);
void         SPITivaDMA_init(SPI_Handle handle);
SPI_Handle   SPITivaDMA_open(SPI_Handle handle, SPI_Params *params);
void         SPITivaDMA_serviceISR(SPI_Handle handle);
bool         SPITivaDMA_transfer(SPI_Handle handle, SPI_Transaction *transaction);
void         SPITivaDMA_transferCancel(SPI_Handle handle);
static void  SPITivaDMA_transferCallback(SPI_Handle handle,
                                         SPI_Transaction *transaction);

/* SPI function table for SPITivaDMA implementation */
const SPI_FxnTable SPITivaDMA_fxnTable = {
    SPITivaDMA_close,
    SPITivaDMA_control,
    SPITivaDMA_init,
    SPITivaDMA_open,
    SPITivaDMA_transfer,
    SPITivaDMA_transferCancel,
    SPITivaDMA_serviceISR
};

static const uint32_t mode[] = {
    SSI_MODE_MASTER,        /* SPI_MASTER */
    SSI_MODE_SLAVE          /* SPI_SLAVE */
};

static const uint32_t frameFormat[] = {
    SSI_FRF_MOTO_MODE_0,    /* SPI_POL0_PHA0 */
    SSI_FRF_MOTO_MODE_1,    /* SPI_POL0_PHA1 */
    SSI_FRF_MOTO_MODE_2,    /* SPI_POL1_PHA0 */
    SSI_FRF_MOTO_MODE_3,    /* SPI_POL1_PHA1 */
    SSI_FRF_TI,             /* SPI_TI */
    SSI_FRF_NMW             /* SPI_MW */
};

/* Default SPI params */
extern const SPI_Params SPI_defaultParams;

/*
 * This lookup table is used to configure the DMA channels for the appropriate
 * (8bit or 16bit) transfer sizes.
 * Table for an SPI DMA TX channel
 */
static const uint32_t dmaTxConfig[] = {
    UDMA_SIZE_8  | UDMA_SRC_INC_8    | UDMA_DST_INC_NONE | UDMA_ARB_4, // 8bit
    UDMA_SIZE_16 | UDMA_SRC_INC_16   | UDMA_DST_INC_NONE | UDMA_ARB_4  // 16bit
};

/*
 * This lookup table is used to configure the DMA channels for the appropriate
 * (8bit or 16bit) transfer sizes.
 * Table for an SPI DMA RX channel
 */
static const uint32_t dmaRxConfig[] = {
    UDMA_SIZE_8  | UDMA_SRC_INC_NONE | UDMA_DST_INC_8    | UDMA_ARB_4, // 8bit
    UDMA_SIZE_16 | UDMA_SRC_INC_NONE | UDMA_DST_INC_16   | UDMA_ARB_4  // 16bit
};

/*
 * This lookup table is used to configure the DMA channels for the appropriate
 * (8bit or 16bit) transfer sizes when either txBuf or rxBuf are NULL
 */
static const uint32_t dmaNullConfig[] = {
    UDMA_SIZE_8  | UDMA_SRC_INC_NONE | UDMA_DST_INC_NONE | UDMA_ARB_4, // 8bit
    UDMA_SIZE_16 | UDMA_SRC_INC_NONE | UDMA_DST_INC_NONE | UDMA_ARB_4  // 16bit
};

/* This lookup table is used to find the appropiate SysCtlPeripheralReset args */
static const uint32_t peripheralResets [] = {
    SYSCTL_PERIPH_SSI0,
    SYSCTL_PERIPH_SSI1,
    SYSCTL_PERIPH_SSI2,
    SYSCTL_PERIPH_SSI3
};

/*
*  ======== SPITivaDMA_hwInit ========
*  This functions initializes the SPI hardware module.
*
*  @pre    Function assumes that the SPI handle is pointing to a hardware
*          module which has already been opened.
*/
static void SPITivaDMA_initHw(SPI_Handle handle, SPI_Params *params)
{
    SPITivaDMA_HWAttrs const *hwAttrs = (SPITivaDMA_HWAttrs *)handle->hwAttrs;

    union {
        Types_FreqHz freq;
        uint32_t     regs[3];
    } data;

    if (!params) {
        data.regs[0] = HWREG(hwAttrs->baseAddr + SSI_O_CR1);
        data.regs[1] = HWREG(hwAttrs->baseAddr + SSI_O_CPSR);
        data.regs[2] = HWREG(hwAttrs->baseAddr + SSI_O_CR0);
    }

    SSIDisable(hwAttrs->baseAddr);
    SysCtlPeripheralReset(peripheralResets[(hwAttrs->baseAddr >> 12) & 0x3]);

    if (params) {
        /* Set the SPI configuration */
        BIOS_getCpuFreq(&(data.freq));
        SSIConfigSetExpClk(hwAttrs->baseAddr,
                           data.freq.lo,
                           frameFormat[params->frameFormat],
                           mode[params->mode],
                           params->bitRate,
                           params->dataSize);

        Log_print3(Diags_USER1, "SPI:(%p) CPU freq: %d; SPI freq to %d",
                                 hwAttrs->baseAddr, data.freq.lo, params->bitRate);
    }
    else {
        /* Write previous register contents */
        HWREG(hwAttrs->baseAddr + SSI_O_CR1)  = data.regs[0];
        HWREG(hwAttrs->baseAddr + SSI_O_CPSR) = data.regs[1];
        HWREG(hwAttrs->baseAddr + SSI_O_CR0)  = data.regs[2];
    }
}

/*
 *  ======== SPITivaDMA_close ========
 *  @pre    Function assumes that the handle is not NULL
 */
void SPITivaDMA_close(SPI_Handle handle)
{
    unsigned int                key;
    SPITivaDMA_Object          *object = handle->object;
    SPITivaDMA_HWAttrs const   *hwAttrs = handle->hwAttrs;

    SSIDisable(hwAttrs->baseAddr);
    uDMAChannelDisable(hwAttrs->txChannelIndex);
    uDMAChannelDisable(hwAttrs->rxChannelIndex);

    /* Destroy the Hwi */
    Hwi_destruct(&(object->hwi));

    if (object->transferMode == SPI_MODE_BLOCKING) {
        Semaphore_destruct(&(object->transferComplete));
    }

    Log_print1(Diags_USER1, "SPI:(%p) closed", hwAttrs->baseAddr);

    key = Hwi_disable();
    object->isOpen = false;
    Hwi_restore(key);
}

/*
 *  ======== SPITivaDMA_control ========
 *  @pre    Function assumes that the handle is not NULL
 */
int SPITivaDMA_control(SPI_Handle handle, unsigned int cmd, void *arg)
{
    /* No implementation yet */
    return (SPI_STATUS_UNDEFINEDCMD);
}

/*
 *  ======== SPITivaDMA_configDMA ========
 *  This functions configures the transmit and receive DMA channels for a given
 *  SPI_Handle and SPI_Transaction
 *
 *  @pre    Function assumes that the handle and transaction is not NULL
 */
static void SPITivaDMA_configDMA(SPI_Handle handle, SPI_Transaction *transaction)
{
    SPIDataType                dummy;
    unsigned int               key;
    void                      *buf;
    uint32_t                   channelControlOptions;
    SPITivaDMA_Object         *object = handle->object;
    SPITivaDMA_HWAttrs const  *hwAttrs = handle->hwAttrs;

    /* Clear out the FIFO */
    while (SSIDataGetNonBlocking(hwAttrs->baseAddr, &dummy)) {
    }

    if (transaction->txBuf) {
        channelControlOptions = dmaTxConfig[object->frameSize];
        buf = transaction->txBuf;
    }
    else {
        channelControlOptions = dmaNullConfig[object->frameSize];
        *hwAttrs->scratchBufPtr = hwAttrs->defaultTxBufValue;
        buf = hwAttrs->scratchBufPtr;
    }

    /* Setup the TX transfer characteristics */
    uDMAChannelControlSet(hwAttrs->txChannelIndex | UDMA_PRI_SELECT,
                          channelControlOptions);

    /* Setup the TX transfer buffers */
    uDMAChannelTransferSet(hwAttrs->txChannelIndex | UDMA_PRI_SELECT,
                           UDMA_MODE_BASIC,
                           buf,
                           (void *)(hwAttrs->baseAddr + SSI_O_DR),
                           transaction->count);

    if (transaction->rxBuf) {
        channelControlOptions = dmaRxConfig[object->frameSize];
        buf = transaction->rxBuf;
    }
    else {
        channelControlOptions = dmaNullConfig[object->frameSize];
        buf = hwAttrs->scratchBufPtr;
    }

    /* Setup the RX transfer characteristics */
    uDMAChannelControlSet(hwAttrs->rxChannelIndex | UDMA_PRI_SELECT,
                          channelControlOptions);

    /* Setup the RX transfer buffers */
    uDMAChannelTransferSet(hwAttrs->rxChannelIndex | UDMA_PRI_SELECT,
                           UDMA_MODE_BASIC,
                           (void *)(hwAttrs->baseAddr + SSI_O_DR),
                           buf,
                           transaction->count);

    Log_print1(Diags_USER1,"SPI:(%p) DMA transfer enabled", hwAttrs->baseAddr);

    Log_print5(Diags_USER2,"SPI:(%p) DMA transaction: %p, "
                           "rxBuf: %p; txBuf: %p; Count: %d",
                            hwAttrs->baseAddr,
                            (UArg)transaction,
                            (UArg)transaction->rxBuf,
                            (UArg)transaction->txBuf,
                            (UArg)transaction->count);

    /* A lock is needed because we are accessing shared uDMA registers.*/
    key = Hwi_disable();

    /* Configure channel mapping */
    hwAttrs->channelMappingFxn(hwAttrs->txChannelMappingFxnArg);
    hwAttrs->channelMappingFxn(hwAttrs->rxChannelMappingFxnArg);

    /* Enable DMA Channels */
    uDMAChannelEnable(hwAttrs->txChannelIndex);
    uDMAChannelEnable(hwAttrs->rxChannelIndex);

    Hwi_restore(key);

#if !defined(MWARE) /* Not supported on Concerto devices */
    if (SSIMODE(hwAttrs->baseAddr)) {
        SSIIntClear(hwAttrs->baseAddr, SSI_DMARX);
        SSIIntEnable(hwAttrs->baseAddr, SSI_DMARX);
    }
#endif
}

/*
 *  ======== SPITivaDMA_hwiFxn ========
 *  ISR for the SPI when we use the DMA
 */
void SPITivaDMA_hwiFxn(UArg arg)
{
    SPI_Transaction           *msg;
    SPITivaDMA_Object         *object = ((SPI_Handle)arg)->object;
    SPITivaDMA_HWAttrs const  *hwAttrs = ((SPI_Handle)arg)->hwAttrs;

    Log_print1(Diags_USER2, "SPI:(%p) interrupt context start",
               hwAttrs->baseAddr);

    /* Determine if the TX and RX DMA channels have completed */
#if defined(MWARE)
    if ((object->transaction) &&
        (uDMAChannelIsEnabled(hwAttrs->rxChannelIndex) == false) &&
        /*
         * MWARE doesn't have UDMA_CHIS (channel interrupt status) registerr
         * defined
         */
        (HWREG(0x400FF504) & (1 << hwAttrs->rxChannelIndex))) {
#else
    if ((object->transaction) &&
        (uDMAChannelIsEnabled(hwAttrs->rxChannelIndex) == false) &&
        (uDMAIntStatus() & (1 << hwAttrs->rxChannelIndex))) {

        if (SSIMODE(hwAttrs->baseAddr)) {
            /* Now we know that the Rx channel may have triggered the interrupt */
            SSIIntDisable(hwAttrs->baseAddr, SSI_DMARX);
            SSIIntClear(hwAttrs->baseAddr, SSI_DMARX);
        }
#endif

        /*
         * Clear any pending interrupt
         * As the TX DMA channel interrupt gets service, it may be possible
         * that the RX DMA channel finished in the meantime, which means
         * the IRQ for RX DMA channel is still pending...
         */
        Hwi_clearInterrupt(hwAttrs->intNum);

        /*
         * Use a temporary transaction pointer in case the callback function
         * attempts to perform another SPI_transfer call
         */
        msg = object->transaction;

        /* Indicate we are done with this transfer */
        object->transaction = NULL;

        Log_print2(Diags_USER1,"SPI:(%p) DMA transaction: %p complete",
                                hwAttrs->baseAddr, (UArg)msg);

        /* Perform callback */
        object->transferCallbackFxn((SPI_Handle)arg, msg);
    }

    Log_print1(Diags_USER2, "SPI:(%p) interrupt context end",
                             hwAttrs->baseAddr);
}

/*
 *  ======== SPITivaDMA_init ========
 *  @pre    Function assumes that the handle is not NULL
 */
void SPITivaDMA_init(SPI_Handle handle)
{
    /* Mark the object as available */
    ((SPITivaDMA_Object *)(handle->object))->isOpen = false;
}

/*
 *  ======== SPITivaDMA_open ========
 *  @pre    Function assumes that the handle is not NULL
 */
SPI_Handle SPITivaDMA_open(SPI_Handle handle, SPI_Params *params)
{
    unsigned int               key;
    SPITivaDMA_Object         *object = handle->object;
    SPITivaDMA_HWAttrs const  *hwAttrs = handle->hwAttrs;
    union {
        Semaphore_Params       semParams;
        Hwi_Params             hwiParams;
    } paramsUnion;

    /* Determine if the device index was already opened */
    key = Hwi_disable();
    if (object->isOpen == true) {
        Hwi_restore(key);
        return (NULL);
    }

    /* Mark the handle as being used */
    object->isOpen = true;
    Hwi_restore(key);

    /* Store the SPI parameters */
    if (params == NULL) {
        /* No params passed in, so use the defaults */
        params = (SPI_Params *) &SPI_defaultParams;
    }

    Assert_isTrue((params->dataSize >= 4) &&
                  (params->dataSize <= 16), NULL);

    /* Determine if we need to use an 8-bit or 16-bit framesize for the DMA */
    object->frameSize = (params->dataSize < 9) ? SPITivaDMA_8bit : SPITivaDMA_16bit;

    Log_print2(Diags_USER2,"SPI:(%p) DMA buffer incrementation size: %s",
                            hwAttrs->baseAddr,
                           (object->frameSize) ? (UArg)"16-bit" : (UArg)"8-bit");

    SSIIntDisable(hwAttrs->baseAddr, SSI_RXOR | SSI_RXFF | SSI_RXTO | SSI_TXFF);

#if !defined(MWARE)
    if (SSIMODE(hwAttrs->baseAddr)) {
        SSIIntDisable(hwAttrs->baseAddr, SSI_DMARX);
    }
#endif

    Hwi_clearInterrupt(hwAttrs->intNum);

    /* Create the Hwi for this SPI peripheral */
    Hwi_Params_init(&(paramsUnion.hwiParams));
    paramsUnion.hwiParams.arg = (UArg)handle;
    paramsUnion.hwiParams.priority = hwAttrs->intPriority;
    Hwi_construct(&(object->hwi), hwAttrs->intNum, SPITivaDMA_hwiFxn,
                  &(paramsUnion.hwiParams), NULL);

    /* Store the current mode */
    object->transferMode = params->transferMode;
    object->transaction = NULL;

    if (object->transferMode == SPI_MODE_BLOCKING) {
        Log_print1(Diags_USER2, "SPI:(%p) in SPI_MODE_BLOCKING mode",
                                 hwAttrs->baseAddr);
        /*
         * Create a semaphore to block task execution for the duration of the
         * SPI transfer
         */
        Semaphore_Params_init(&(paramsUnion.semParams));
        paramsUnion.semParams.mode = Semaphore_Mode_BINARY;
        Semaphore_construct(&(object->transferComplete), 0,
                            &(paramsUnion.semParams));

        /* Store internal callback function */
        object->transferCallbackFxn = SPITivaDMA_transferCallback;

        /* Store SPI transfer timeout */
        object->transferTimeout = params->transferTimeout;
    }
    else {
        Log_print1(Diags_USER2, "SPI:(%p) in SPI_MODE_CALLBACK mode",
                                 hwAttrs->baseAddr);

        /* Check to see if a callback function was defined for async mode */
        Assert_isTrue(params->transferCallbackFxn != NULL, NULL);

        /* Save the callback function pointer */
        object->transferCallbackFxn = params->transferCallbackFxn;
    }

    SPITivaDMA_initHw(handle, params);

    SSIDMAEnable(hwAttrs->baseAddr, SSI_DMA_TX | SSI_DMA_RX);

    SSIEnable(hwAttrs->baseAddr);

    Log_print1(Diags_USER1, "SPI:(%p) opened", hwAttrs->baseAddr);

    return (handle);
}

/*
 *  ======== SPITivaDMA_serviceISR ========
 */
void SPITivaDMA_serviceISR(SPI_Handle handle)
{
    /* Function is not supported */
    Assert_isTrue(false, NULL);
}

/*
 *  ======== SPITivaDMA_transfer ========
 *  @pre    Function assumes that handle and transaction is not NULL
 */
bool SPITivaDMA_transfer(SPI_Handle handle, SPI_Transaction *transaction)
{
    unsigned int               key;
    SPITivaDMA_Object         *object = handle->object;
    SPITivaDMA_HWAttrs const  *hwattrs = handle->hwAttrs;

    /* Check the transaction arguments */
    if ((transaction->count == 0) || (transaction->count > 1024) ||
       !(transaction->rxBuf || transaction->txBuf) ||
      (!(transaction->rxBuf && transaction->txBuf) && !hwattrs->scratchBufPtr)) {
        return (false);
    }

    /* Make sure that the buffers are aligned properly */
    if (object->frameSize == SPITivaDMA_16bit) {
        Assert_isTrue(!((uint32_t)transaction->txBuf & 0x1), NULL);
        Assert_isTrue(!((uint32_t)transaction->rxBuf & 0x1), NULL);
    }

    /* Check if a transfer is in progress */
    key = Hwi_disable();
    if (object->transaction) {
        Hwi_restore(key);

        Log_error1("SPI:(%p) transaction still in progress",
                   hwattrs->baseAddr);

        /* Transfer is in progress */
        return (false);
    }
    else {
        /* Save the pointer to the transaction */
        object->transaction = transaction;
    }
    Hwi_restore(key);

    SPITivaDMA_configDMA(handle, transaction);

    if (object->transferMode == SPI_MODE_BLOCKING) {
        Log_print1(Diags_USER1,
                   "SPI:(%p) transfer pending on transferComplete semaphore",
                    hwattrs->baseAddr);

        if (!Semaphore_pend(Semaphore_handle(&(object->transferComplete)),
                            object->transferTimeout)) {

            /*
             * Transfer has timed out.
             * Bring the SPI driver back to a known good state.
             */
            SPITivaDMA_transferCancel(handle);

            return(false);
        }
    }

    return (true);
}

/*
 *  ======== SPITivaDMA_transferCancel ========
 *  A function to cancel a transaction (if one is in progress) when the driver
 *  is in SPI_MODE_CALLBACK.
 *
 *  @pre    Function assumes that the handle is not NULL
 */
void SPITivaDMA_transferCancel(SPI_Handle handle)
{
    SPIDataType                dummy;
    SPITivaDMA_Object         *object = handle->object;
    SPITivaDMA_HWAttrs const  *hwattrs = handle->hwAttrs;

    SSIDMADisable(hwattrs->baseAddr, SSI_DMA_RX);

    /* Prevent an SPI interrupt from modifying the queue */
    Hwi_disableInterrupt(hwattrs->intNum);

    uDMAChannelDisable(hwattrs->txChannelIndex);
    uDMAChannelDisable(hwattrs->rxChannelIndex);

#if !defined(MWARE)
    if (SSIMODE(hwattrs->baseAddr)) {
        /* Now we know that the Rx channel may have triggered the interrupt */
        SSIIntDisable(hwattrs->baseAddr, SSI_DMARX);
        SSIIntClear(hwattrs->baseAddr, SSI_DMARX);
    }
#endif

    SPITivaDMA_initHw(handle, NULL);
    SSIDMAEnable(hwattrs->baseAddr, SSI_DMA_TX | SSI_DMA_RX);

    SSIEnable(hwattrs->baseAddr);

    /*
     * Clear any pending interrupt
     * As the TX DMA channel interrupt gets service, it may be possible
     * that the RX DMA channel finished in the meantime, which means
     * the IRQ for RX DMA channel is still pending...
     */
    Hwi_clearInterrupt(hwattrs->intNum);

	/* Indicate we are done with this transfer */
    object->transaction = NULL;

    /* Clear out the FIFO */
    while (SSIDataGetNonBlocking(hwattrs->baseAddr, &dummy));

    Hwi_enableInterrupt(hwattrs->intNum);
}

/*
 *  ======== SPITivaDMA_transferCallback ========
 *  Callback function for when the SPI is in SPI_MODE_BLOCKING
 *
 *  @pre    Function assumes that the handle is not NULL
 */
static void SPITivaDMA_transferCallback(SPI_Handle handle,
                                        SPI_Transaction *transaction)
{
    SPITivaDMA_Object         *object = handle->object;

    Log_print1(Diags_USER1, "SPI:(%p) posting transferComplete semaphore",
                ((SPITivaDMA_HWAttrs const *)(handle->hwAttrs))->baseAddr);

    Semaphore_post(Semaphore_handle(&(object->transferComplete)));
}
