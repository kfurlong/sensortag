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
#include <xdc/runtime/Assert.h>
#include <xdc/runtime/Diags.h>
#include <xdc/runtime/Log.h>
#include <xdc/runtime/Types.h>

#include <ti/drivers/uart/UARTUSCIA.h>

#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/knl/Semaphore.h>
#include <ti/sysbios/hal/Hwi.h>
#include <ti/sysbios/family/msp430/ClockFreqs.h>

/* driverlib header files */
#include <usci_a_uart.h>
#include <ucs.h>

extern const UART_Config UART_config[];

/* Prototypes */
void         UARTUSCIA_close(UART_Handle handle);
int          UARTUSCIA_control(UART_Handle handle, unsigned int cmd, void *arg);
void         UARTUSCIA_init(UART_Handle handle);
UART_Handle  UARTUSCIA_open(UART_Handle handle, UART_Params *params);
int          UARTUSCIA_read(UART_Handle handle, void *buffer, size_t size);
void         UARTUSCIA_readCancel(UART_Handle handle);
int          UARTUSCIA_readPolling(UART_Handle handle, void *buffer,
                                   size_t size);
int          UARTUSCIA_write(UART_Handle handle, const void *buffer,
                             size_t size);
void         UARTUSCIA_writeCancel(UART_Handle handle);
int          UARTUSCIA_writePolling(UART_Handle handle,
                                    const void *buffer, size_t size);

/* UARTUSCIA function table for UARTUSCIA implementation */
const UART_FxnTable UARTUSCIA_fxnTable = {
    UARTUSCIA_close,
    UARTUSCIA_control,
    UARTUSCIA_init,
    UARTUSCIA_open,
    UARTUSCIA_read,
    UARTUSCIA_readPolling,
    UARTUSCIA_readCancel,
    UARTUSCIA_write,
    UARTUSCIA_writePolling,
    UARTUSCIA_writeCancel,
};

static const uint32_t stopBits[] = {
    USCI_A_UART_ONE_STOP_BIT,   /* UART_STOP_ONE */
    USCI_A_UART_TWO_STOP_BITS   /* UART_STOP_TWO */
};

static const uint32_t parityType[] = {
    USCI_A_UART_NO_PARITY,      /* UART_PAR_NONE */
    USCI_A_UART_EVEN_PARITY,    /* UART_PAR_EVEN */
    USCI_A_UART_ODD_PARITY,     /* UART_PAR_ODD */
    0,                          /* UART_PAR_ZERO */
    1                           /* UART_PAR_ONE */
};

/* Default UART params */
extern const UART_Params UART_defaultParams;

/*
 *  ======== findBaudDividers ========
 *  This function searchs a given array of different baudrate configurations to
 *  find the first compatible match given the desired buadrate and the currently
 *  configured clock input frequency.
 *
 *  It return the index in if the UARTUSCIA_BaudrateConfig table if a match was
 *  found, else it will return -1
 */
static int32_t findBaudDividerIndex(UARTUSCIA_BaudrateConfig const *table,
                                    uint32_t tableSize,
                                    uint32_t baudrate,
                                    uint32_t clockFreq)
{
    int32_t  index;

    Assert_isTrue((tableSize != 0) && (table != NULL), NULL);

    for (index = 0; index < tableSize; index++) {
        if ((table[index].outputBaudrate == baudrate) &&
            (table[index].inputClockFreq == clockFreq)) {
            return (index);
        }
    }
    return (-1);
}

/*
 *  ======== writeSemCallback ========
 *  Simple callback to post a semaphore for the blocking mode.
 */
static void writeSemCallback(UART_Handle handle, void *buffer, size_t count)
{
    UARTUSCIA_Object *object = handle->object;

    Semaphore_post(Semaphore_handle(&(object->writeSem)));
}

/*
 *  ======== readSemCallback ========
 *  Simple callback to post a semaphore for the blocking mode.
 */
static void readSemCallback(UART_Handle handle, void *buffer, size_t count)
{
    UARTUSCIA_Object *object = handle->object;

    Semaphore_post(Semaphore_handle(&(object->readSem)));
}

/*
 *  ======== writeData ========
 *  Write and process data to the UARTUSCIA.
 */
static void writeData(UARTUSCIA_Object        *object,
                      UARTUSCIA_HWAttrs const *hwAttrs)
{
    /* If mode is TEXT process the characters */
    if (object->writeDataMode == UART_DATA_TEXT) {
        if (object->writeCR) {
            USCI_A_UART_transmitData(hwAttrs->baseAddr, '\r');
            Log_print2(Diags_USER2, "UART:(%p) Wrote 0x%x",
                                     hwAttrs->baseAddr, '\r');
            object->writeSize--;
            object->writeCount++;
            object->writeCR = false;
        }
        else {
            /* Add a return if next character is a newline. */
           if (*(unsigned char *)object->writeBuf == '\n') {
               object->writeSize++;
               object->writeCR = true;
           }
           USCI_A_UART_transmitData(hwAttrs->baseAddr,
                                  *(unsigned char *)object->writeBuf);
           Log_print2(Diags_USER2, "UART:(%p) Wrote 0x%x",
                                    hwAttrs->baseAddr,
                                   *(unsigned char *)object->writeBuf);
           object->writeBuf = (unsigned char *)object->writeBuf + 1;
           object->writeSize--;
           object->writeCount++;
        }
    }
    else {
        USCI_A_UART_transmitData(hwAttrs->baseAddr,
                               *(unsigned char *)object->writeBuf);
        Log_print2(Diags_USER2, "UART:(%p) Wrote 0x%x",
                                 hwAttrs->baseAddr,
                                *(unsigned char *)object->writeBuf);
        object->writeBuf = (unsigned char *)object->writeBuf + 1;
        object->writeSize--;
        object->writeCount++;
    }
}

/*
 *  ======== readData ========
 *  Read and process data from the UARTUSCIA.
 */
static void readData(UARTUSCIA_Object         *object,
                     UARTUSCIA_HWAttrs const  *hwAttrs)
{
    uint8_t readIn;

    /* Receive char */
    readIn = USCI_A_UART_receiveData(hwAttrs->baseAddr);

    /* If data mode is set to TEXT replace return with a newline. */
    if (object->readDataMode == UART_DATA_TEXT) {
        if (readIn == '\r') {
            /* Echo character if enabled. */
            if (object->readEcho) {
                /* Wait until TX is ready */
                while (!USCI_A_UART_getInterruptStatus(hwAttrs->baseAddr,
                            USCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
                USCI_A_UART_transmitData(hwAttrs->baseAddr, '\r');
            }
            readIn = '\n';
        }
    }

    /* Echo character if enabled. */
    if (object->readEcho) {
        /* Wait until TX is ready */
        while (!USCI_A_UART_getInterruptStatus(hwAttrs->baseAddr,
                    USCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
        USCI_A_UART_transmitData(hwAttrs->baseAddr, readIn);
    }

    Log_print2(Diags_USER2, "UART:(%p) Read 0x%x",
                             hwAttrs->baseAddr, readIn);
    *(unsigned char *)object->readBuf = readIn;
    object->readBuf = (unsigned char *)object->readBuf + 1;
    object->readCount++;
    object->readSize--;

    /* If read return mode is newline, finish if a newline was received. */
    if (object->readReturnMode == UART_RETURN_NEWLINE && readIn == '\n') {
        Log_print1(Diags_USER2, "UART:(%p) Newline received, "
                                "returning",
                                 hwAttrs->baseAddr);
        object->readSize = 0;
    }
}

/*
 *  ======== UARTUSCIA_hwiIntFxn ========
 *  Hwi function that processes UARTUSCIA interrupts.
 *
 *  writeData and readData are in-lined functions that will read/write data
 *  with processing if enabled.  When the read or write is finished they will
 *  post the semaphore or make the callback and log the transfer.
 *
 *  @param(UARTUSCIAObject)       The UARTUSCIA_Object for this Hwi.
 */
void UARTUSCIA_hwiIntFxn(UArg index)
{
    uint8_t                     status;
    UARTUSCIA_Object           *object = (&UART_config[index])->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = (&UART_config[index])->hwAttrs;

    /* Clear interrupts */
    status = USCI_A_UART_getInterruptStatus(hwAttrs->baseAddr,
             USCI_A_UART_RECEIVE_INTERRUPT_FLAG |
             USCI_A_UART_TRANSMIT_INTERRUPT_FLAG);

    if (status & USCI_A_UART_RECEIVE_INTERRUPT_FLAG) {
        /* Read data if characters are available. */
        if (object->readSize) {
            readData(object, hwAttrs);
            if (!object->readSize) {
                /* Reset the read buffer so we can pass it back */
                object->readBuf = (unsigned char *)object->readBuf - object->readCount;
                object->readCallback((UART_Handle)&UART_config[index], object->readBuf,
                                            object->readCount);
                Log_print2(Diags_USER1, "UART:(%p) Read finished, "
                                        "%d bytes read",
                                         hwAttrs->baseAddr, object->readCount);
                /* Disable RX interrupt until we do a new read */
                USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
                        USCI_A_UART_RECEIVE_INTERRUPT);
            }
        }
    }

    if (status & USCI_A_UART_TRANSMIT_INTERRUPT_FLAG) {
        /* Write if there are characters to be written. */
        if (object->writeSize > 0) {
            writeData(object, hwAttrs);
            if (object->writeSize == 0) {
                /* Reset the write buffer so we can pass it back */
                object->writeBuf = (unsigned char *)object->writeBuf - object->writeCount;
                object->writeCallback((UART_Handle)&UART_config[index],
                                             (uint8_t*)object->writeBuf,
                                             object->writeCount);
                Log_print2(Diags_USER1, "UART:(%p) Write finished, "
                                        "%d bytes written",
                                         hwAttrs->baseAddr, object->writeCount);

                /* Disable TX interrupt until we do a new write */
                USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
                        USCI_A_UART_TRANSMIT_INTERRUPT);
            }
        }
    }
}

/*
 *  ======== UARTUSCIA_init ========
 */
void UARTUSCIA_init(UART_Handle handle)
{
    UARTUSCIA_Object *object = handle->object;

    object->isOpen = false;
}

/*
 *  ======== UARTUSCIA_open ========
 */
UART_Handle UARTUSCIA_open(UART_Handle handle, UART_Params *params)
{
    unsigned int                key;
    uint32_t                    clockFreq;
    int32_t                     baudrateIndex;
    USCI_A_UART_initParam       usciUartParams;
    Semaphore_Params            semParams;
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* If params are NULL use defaults. */
    if (params == NULL) {
        params = (UART_Params *) &UART_defaultParams;
    }

    object->readMode       = params->readMode;
    object->writeMode      = params->writeMode;
    object->readTimeout    = params->readTimeout;
    object->writeTimeout   = params->writeTimeout;
    object->readCallback   = params->readCallback;
    object->writeCallback  = params->writeCallback;
    object->readReturnMode = params->readReturnMode;
    object->readDataMode   = params->readDataMode;
    object->writeDataMode  = params->writeDataMode;
    object->readEcho       = params->readEcho;

    /* Get the SPI clock input frequency */
    switch (hwAttrs->clockSource) {
        case USCI_A_UART_CLOCKSOURCE_ACLK:
            clockFreq = ClockFreqs_getFrequency(ClockFreqs_Clock_ACLK);
            Log_print1(Diags_USER1, "ClockFreqs_getFrequency ACLK: %d", clockFreq);
            break;

        case USCI_A_UART_CLOCKSOURCE_SMCLK:
            clockFreq = ClockFreqs_getFrequency(ClockFreqs_Clock_SMCLK);
            Log_print1(Diags_USER1, "ClockFreqs_getFrequency SMCLK: %d", clockFreq);
            break;


        default:
            Log_error1("UART:(%p) Error determining clock source",
                        hwAttrs->baseAddr);
            return (NULL);
    }

    /* Find a valid baudrate configuration for USCI_A_UART_initAdvance() */
    baudrateIndex = findBaudDividerIndex(hwAttrs->baudrateLUT,
                                         hwAttrs->numBaudrateEntries,
                                         params->baudRate,
                                         clockFreq);
    if (baudrateIndex == -1) {
        Log_error3("UART:(%p) unable to find a valid buadrate %d "
                   "configuration at clock input clock freq %d",
                   hwAttrs->baseAddr,
                   params->baudRate,
                   clockFreq);
        return (NULL);
    }

    /* Check that a callback is set */
    Assert_isTrue((params->readMode != UART_MODE_CALLBACK) ||
                  (params->readCallback != NULL), NULL);
    Assert_isTrue((params->writeMode != UART_MODE_CALLBACK) ||
                  (params->writeCallback != NULL), NULL);

    /* Disable preemption while checking if the UART is open. */
    key = Hwi_disable();

    /* Check if the UARTUSCIA is open already with the base addr. */
    if (object->isOpen) {
        Hwi_restore(key);
        Log_warning1("UART:(%p) already in use.", hwAttrs->baseAddr);
        return (NULL);
    }

    /* UART is now open */
    object->isOpen = true;
    Hwi_restore(key);

    /* Save paramters */
    object->writeBuf = NULL;
    object->readBuf = NULL;
    object->writeCount = 0;
    object->readCount = 0;
    object->writeSize = 0;
    object->readSize = 0;
    object->writeCR = false;

    /* If write mode is blocking create a semaphore and set callback. */
    if (object->writeMode == UART_MODE_BLOCKING) {
        Semaphore_Params_init(&semParams);
        semParams.mode = Semaphore_Mode_BINARY;
        Semaphore_construct(&(object->writeSem), 0, &semParams);
        object->writeCallback = &writeSemCallback;
    }

    /* If read mode is blocking create a semaphore and set callback. */
    if (object->readMode == UART_MODE_BLOCKING) {
        Semaphore_Params_init(&semParams);
        semParams.mode = Semaphore_Mode_BINARY;
        Semaphore_construct(&(object->readSem), 0, &semParams);
        object->readCallback = &readSemCallback;
    }

    usciUartParams.selectClockSource = hwAttrs->clockSource;
    usciUartParams.clockPrescalar = hwAttrs->baudrateLUT[baudrateIndex].prescalar;
    usciUartParams.firstModReg = hwAttrs->baudrateLUT[baudrateIndex].hwRegUCBRFx;
    usciUartParams.secondModReg = hwAttrs->baudrateLUT[baudrateIndex].hwRegUCBRSx;
    usciUartParams.parity = parityType[params->parityType];
    usciUartParams.msborLsbFirst = hwAttrs->bitOrder;
    usciUartParams.numberofStopBits = stopBits[params->stopBits];
    usciUartParams.uartMode = USCI_A_UART_MODE;
    usciUartParams.overSampling = hwAttrs->baudrateLUT[baudrateIndex].sampling;
    if (STATUS_FAIL == USCI_A_UART_init(hwAttrs->baseAddr, &usciUartParams)) {
        Log_error3("UART:(%p) initAdvance() failure "
                   "CPU freq: %d; "
                   "UART baudrate to %d",
                    hwAttrs->baseAddr,
                    clockFreq,
                    params->baudRate);
        UARTUSCIA_close(handle);
        return (NULL);
    }

    /* Disable UART interrupts and enable it. */
    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_RECEIVE_INTERRUPT);
    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_TRANSMIT_INTERRUPT);
    USCI_A_UART_enable(hwAttrs->baseAddr);

    Log_print1(Diags_USER1, "UART:(%p) opened", hwAttrs->baseAddr);

    /* Return the handle */
    return (handle);
}

/*
 *  ======== UARTUSCIA_close ========
 */
void UARTUSCIA_close(UART_Handle handle)
{
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_RECEIVE_INTERRUPT);
    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_TRANSMIT_INTERRUPT);
    USCI_A_UART_disable(hwAttrs->baseAddr);

    if (object->writeMode == UART_MODE_BLOCKING) {
        Semaphore_destruct(&(object->writeSem));
    }

    if (object->readMode == UART_MODE_BLOCKING) {
        Semaphore_destruct(&(object->readSem));
    }

    object->isOpen = false;

    Log_print1(Diags_USER1, "UART:(%p) closed", hwAttrs->baseAddr);
}

/*
 *  ======== UARTUSCIA_control ========
 *  @pre    Function assumes that the handle is not NULL
 */
int UARTUSCIA_control(UART_Handle handle, unsigned int cmd, void *arg)
{
    /* No implementation yet */
    return (UART_STATUS_UNDEFINEDCMD);
}

/*
 *  ======== UARTUSCIA_write ========
 */
int UARTUSCIA_write(UART_Handle handle, const void *buffer, size_t size)
{
    unsigned int                key;
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Check that there is data to write */
    Assert_isTrue(size != 0, NULL);

    /* Disable preemption while checking if the uart is in use. */
    key = Hwi_disable();
    if (object->writeSize != 0) {
        Hwi_restore(key);
        Log_warning1("UART:(%p) Could not write data, uart in use.",
                      hwAttrs->baseAddr);
        return (UART_ERROR);
    }

    /* Save the data to be written and restore interrupts. */
    object->writeBuf = buffer;
    object->writeSize = size;
    object->writeCount = 0;

    Hwi_restore(key);

    /* Enabling TX interrupt will trigger the Hwi which will handle the write */
    USCI_A_UART_enableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_TRANSMIT_INTERRUPT);

    /* If writeMode is blocking, block and get the status. */
    if (object->writeMode == UART_MODE_BLOCKING) {
        /* Pend on semaphore and wait for Hwi to finish. */
        if (!Semaphore_pend(Semaphore_handle(&object->writeSem),
                    object->writeTimeout)) {
            /* Semaphore timed out, make the write empty and log the write. */
            USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
                    USCI_A_UART_TRANSMIT_INTERRUPT);
            object->writeSize = 0;

            Log_print2(Diags_USER1, "UART:(%p) Write timed out, "
                                    "%d bytes written",
                                     hwAttrs->baseAddr,
                                     object->writeCount);

        }
        return (object->writeCount);
    }

    /* UART_MODE_CALLBACK returns 0 */
    return (0);
}

/*
 *  ======== UARTUSCIA_writePolling ========
 */
int UARTUSCIA_writePolling(UART_Handle handle, const void *buffer, size_t size)
{
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Save the data to be written and restore interrupts. */
    object->writeBuf = buffer;
    object->writeSize = size;
    object->writeCount = 0;

    while (object->writeSize) {
        /* Wait until we can TX a byte */
        while (!USCI_A_UART_getInterruptStatus(hwAttrs->baseAddr,
                    USCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
        writeData(object, hwAttrs);
    }

    Log_print2(Diags_USER1, "UART:(%p) Write polling finished, "
                            "%d bytes written",
                             hwAttrs->baseAddr,
                             object->writeCount);


    return (object->writeCount);
}

/*
 *  ======== UARTUSCIA_writeCancel ========
 */
void UARTUSCIA_writeCancel(UART_Handle handle)
{
    unsigned int                key;
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Disable interrupts to avoid writing data while changing state. */
    key = Hwi_disable();

    /* Return if there is no write. */
    if (!object->writeSize) {
        Hwi_restore(key);
        return;
    }

    /* Set size = 0 to prevent writing and restore interrupts. */
    object->writeSize = 0;
    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_TRANSMIT_INTERRUPT);
    Hwi_restore(key);

    /* Reset the write buffer so we can pass it back */
    object->writeBuf = (unsigned char *)object->writeBuf - object->writeCount;
    object->writeCallback(handle, (uint8_t*)object->writeBuf,
                                 object->writeCount);

    Log_print2(Diags_USER1, "UART:(%p) Write canceled, "
                            "%d bytes written",
                             hwAttrs->baseAddr,
                             object->writeCount);
}

/*
 *  ======== UARTUSCIA_read ========
 */
int UARTUSCIA_read(UART_Handle handle, void *buffer, size_t size)
{
    unsigned int                key;
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Disable preemption while checking if the uart is in use. */
    key = Hwi_disable();
    if (object->readSize) {
        Hwi_restore(key);
        Log_warning1("UART:(%p) Could not read data, uart in use.",
                      hwAttrs->baseAddr);
        return (UART_ERROR);
    }

    /* Save the data to be read and restore interrupts. */
    object->readBuf = buffer;
    object->readSize = size;
    object->readCount = 0;

    Hwi_restore(key);

    /* Enabling RX interrupt will trigger the Hwi which will handle the read */
    USCI_A_UART_enableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_RECEIVE_INTERRUPT);

    /* If readMode is blocking, block and get the status. */
    if (object->readMode == UART_MODE_BLOCKING) {
        /* Pend on semaphore and wait for Hwi to finish. */
        if (!Semaphore_pend(Semaphore_handle(&object->readSem),
                    object->readTimeout)) {
            /* Semaphore timed out, make the read empty and log the read. */
            USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
                    USCI_A_UART_RECEIVE_INTERRUPT);
            object->readSize = 0;
            Log_print2(Diags_USER1, "UART:(%p) Read timed out, "
                                    "%d bytes read",
                                     hwAttrs->baseAddr,
                                     object->readCount);
        }
        return (object->readCount);
    }

    /* UART_MODE_CALLBACK returns 0 */
    return (0);
}

/*
 *  ======== UARTUSCIA_readPolling ========
 */
int UARTUSCIA_readPolling(UART_Handle handle, void *buffer, size_t size)
{
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Save the data to be read and restore interrupts. */
    object->readBuf = buffer;
    object->readSize = size;
    object->readCount = 0;

    while (object->readSize) {
        /* Wait until we have RX a byte */
        while (!USCI_A_UART_getInterruptStatus(hwAttrs->baseAddr,
                    USCI_A_UART_RECEIVE_INTERRUPT_FLAG));
        readData(object, hwAttrs);
     }

    Log_print2(Diags_USER1, "UART:(%p) Read polling finished, "
                            "%d bytes read",
                             hwAttrs->baseAddr,
                             object->readCount);

    return (object->readCount);
}

/*
 *  ======== UARTUSCIA_readCancel ========
 */
void UARTUSCIA_readCancel(UART_Handle handle)
{
    unsigned int                key;
    UARTUSCIA_Object           *object = handle->object;
    UARTUSCIA_HWAttrs const    *hwAttrs = handle->hwAttrs;

    /* Disable interrupts to avoid reading data while changing state. */
    key = Hwi_disable();

    /* Return if there is no read. */
    if (!object->readSize) {
        Hwi_restore(key);
        return;
    }

    /* Set size = 0 to prevent reading and restore interrupts. */
    object->readSize = 0;
    USCI_A_UART_disableInterrupt(hwAttrs->baseAddr,
            USCI_A_UART_RECEIVE_INTERRUPT);
    Hwi_restore(key);

    /* Reset the read buffer so we can pass it back */
    object->readBuf = (unsigned char *)object->readBuf - object->readCount;
    object->readCallback(handle, object->readBuf, object->readCount);

    Log_print2(Diags_USER1, "UART:(%p) Read canceled, "
                            "%d bytes read",
                             hwAttrs->baseAddr,
                             object->readCount);
}
