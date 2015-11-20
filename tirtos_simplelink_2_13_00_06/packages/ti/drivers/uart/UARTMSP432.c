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
#include <stdbool.h>

/*
 * By default disable both asserts and log for this module.
 * This must be done before DebugP.h is included.
 */
#ifndef DebugP_ASSERT_ENABLED
#define DebugP_ASSERT_ENABLED 0
#endif
#ifndef DebugP_LOG_ENABLED
#define DebugP_LOG_ENABLED 0
#endif

#include <ti/drivers/ports/ClockP.h>
#include <ti/drivers/ports/DebugP.h>
#include <ti/drivers/ports/HwiP.h>
#include <ti/drivers/ports/SemaphoreP.h>

#include <ti/drivers/Power.h>
#include <ti/drivers/power/PowerMSP432.h>
#include <ti/drivers/UART.h>
#include <ti/drivers/uart/UARTMSP432.h>

/* driverlib header files */
#include <rom.h>
#include <rom_map.h>
#include <uart.h>

/* UARTMSP432 functions */
void UARTMSP432_close(UART_Handle handle);
int UARTMSP432_control(UART_Handle handle, unsigned int cmd, void *arg);
void UARTMSP432_init(UART_Handle handle);
UART_Handle UARTMSP432_open(UART_Handle handle, UART_Params *params);
int UARTMSP432_read(UART_Handle handle, void *buffer, size_t size);
void UARTMSP432_readCancel(UART_Handle handle);
int UARTMSP432_readPolling(UART_Handle handle, void *buffer, size_t size);
int UARTMSP432_write(UART_Handle handle, const void *buffer, size_t size);
void UARTMSP432_writeCancel(UART_Handle handle);
int UARTMSP432_writePolling(UART_Handle handle, const void *buffer, size_t size);
static void errorCallback(UART_Handle handle, uintptr_t error);
static int32_t findBaudDividerIndex(UARTMSP432_BaudrateConfig const *table,
    uint32_t tableSize, uint32_t baudrate, uint32_t clockFreq);
static void initHw(UARTMSP432_Object *object,
    UARTMSP432_HWAttrs const *hwAttrs, uint32_t inputClkFreq);
static int perfChangeNotifyFxn(unsigned int eventType, uintptr_t eventArg,
    uintptr_t clientArg);
static void readBlockingTimeout(uintptr_t arg);
static bool readIsrBinaryBlocking(UART_Handle handle);
static bool readIsrBinaryCallback(UART_Handle handle);
static bool readIsrTextBlocking(UART_Handle handle);
static bool readIsrTextCallback(UART_Handle handle);
static void readSemCallback(UART_Handle handle, void *buffer, size_t count);
static int readTaskBlocking(UART_Handle handle);
static int readTaskCallback(UART_Handle handle);
static void writeData(UART_Handle handle);
static void writeSemCallback(UART_Handle handle, void *buffer, size_t count);

/* UART function table for UARTMP432 implementation */
const UART_FxnTable UARTMSP432_fxnTable = {
    UARTMSP432_close,
    UARTMSP432_control,
    UARTMSP432_init,
    UARTMSP432_open,
    UARTMSP432_read,
    UARTMSP432_readPolling,
    UARTMSP432_readCancel,
    UARTMSP432_write,
    UARTMSP432_writePolling,
    UARTMSP432_writeCancel,
};

static const uint16_t stopBits[] = {
    EUSCI_A_UART_ONE_STOP_BIT,  /* UART_STOP_ONE */
    EUSCI_A_UART_TWO_STOP_BITS  /* UART_STOP_TWO */
};

static const uint8_t parityTypes[] = {
    EUSCI_A_UART_NO_PARITY,     /* UART_PAR_NONE */
    EUSCI_A_UART_EVEN_PARITY,   /* UART_PAR_EVEN */
    EUSCI_A_UART_ODD_PARITY,    /* UART_PAR_ODD */
    0,                          /* UART_PAR_ZERO */
    1                           /* UART_PAR_ONE */
};

/*
 *  ======== staticFxnTable ========
 *  This is a function lookup table to simplify the UART driver modes.
 */
static const UARTMSP432_FxnSet staticFxnTable[2][2] = {
    {/* UART_MODE_BLOCKING */
        {/* UART_DATA_BINARY */
            .readIsrFxn  = readIsrBinaryBlocking,
            .readTaskFxn = readTaskBlocking
        },
        {/* UART_DATA_TEXT */
            .readIsrFxn  = readIsrTextBlocking,
            .readTaskFxn = readTaskBlocking
        }
    },
    {/* UART_MODE_CALLBACK */
        {/* UART_DATA_BINARY */
            .readIsrFxn  = readIsrBinaryCallback,
            .readTaskFxn = readTaskCallback

        },
        {/* UART_DATA_TEXT */
            .readIsrFxn  = readIsrTextCallback,
            .readTaskFxn = readTaskCallback,
        }
    }
};

/* Default UART params */
extern const UART_Params UART_defaultParams;

/*
 *  ======== errorCallback ========
 *  Generic log function for when unexpected events occur.
 */
static void errorCallback(UART_Handle handle, uintptr_t error)
{
    if (error & EUSCI_A_UART_OVERRUN_ERROR) {
        DebugP_log1("UART:(%p): OVERRUN ERROR",
            ((UARTMSP432_HWAttrs const *)handle->hwAttrs)->baseAddr);
    }
    if (error & EUSCI_A_UART_BREAK_DETECT) {
        DebugP_log1("UART:(%p): BREAK ERROR",
            ((UARTMSP432_HWAttrs const *)handle->hwAttrs)->baseAddr);
    }
    if (error & EUSCI_A_UART_PARITY_ERROR) {
        DebugP_log1("UART:(%p): PARITY ERROR",
            ((UARTMSP432_HWAttrs const *)handle->hwAttrs)->baseAddr);
    }
    if (error & EUSCI_A_UART_FRAMING_ERROR) {
        DebugP_log1("UART:(%p): FRAMING ERROR",
            ((UARTMSP432_HWAttrs const *)handle->hwAttrs)->baseAddr);
    }
}

/*
 *  ======== findBaudDividerIndex ========
 *  This function searchs a given array of different baudrate configurations to
 *  find the first compatible match given the desired buadrate and the currently
 *  configured clock input frequency.
 *
 *  It return the index in if the UARTMSP432_BaudrateConfig table if a match was
 *  found, else it will return -1
 */
static int32_t findBaudDividerIndex(UARTMSP432_BaudrateConfig const *table,
    uint32_t tableSize, uint32_t baudrate, uint32_t clockFreq)
{
    int32_t index;

    DebugP_assert((tableSize != 0) && (table != NULL));

    for (index = 0; index < tableSize; index++) {
        if ((table[index].outputBaudrate == baudrate) &&
            (table[index].inputClockFreq == clockFreq)) {
            return (index);
        }
    }
    return (-1);
}

/*
 *  ======== initHW ========
 *
 *  Configures UART peripheral
 */
static void initHw(UARTMSP432_Object *object,
    UARTMSP432_HWAttrs const *hwAttrs, uint32_t inputClkFreq)
{
    int32_t           baudrateIndex;
    eUSCI_UART_Config uartConfig;

    /*
     * This will never return -1, constarints prevent unsupported performance
     * levels
     */
    baudrateIndex = findBaudDividerIndex(hwAttrs->baudrateLUT,
        hwAttrs->numBaudrateEntries, object->baudRate, inputClkFreq);

    uartConfig.selectClockSource = hwAttrs->clockSource;
    uartConfig.clockPrescalar = hwAttrs->baudrateLUT[baudrateIndex].prescalar;
    uartConfig.firstModReg = hwAttrs->baudrateLUT[baudrateIndex].hwRegUCBRFx;
    uartConfig.secondModReg = hwAttrs->baudrateLUT[baudrateIndex].hwRegUCBRSx;
    uartConfig.parity = parityTypes[object->parityType];
    uartConfig.msborLsbFirst = hwAttrs->bitOrder;
    uartConfig.numberofStopBits = stopBits[object->stopBits];
    uartConfig.uartMode = EUSCI_A_UART_MODE;
    uartConfig.overSampling = hwAttrs->baudrateLUT[baudrateIndex].sampling;

    MAP_UART_initModule(hwAttrs->baseAddr, &uartConfig);

    /* Enable UART and disable its interrupts. */
    MAP_UART_enableInterrupt(hwAttrs->baseAddr,
        EUSCI_A_UART_BREAKCHAR_INTERRUPT |
        EUSCI_A_UART_RECEIVE_ERRONEOUSCHAR_INTERRUPT);
    MAP_UART_disableInterrupt(hwAttrs->baseAddr, EUSCI_A_UART_TRANSMIT_INTERRUPT);

    MAP_UART_enableModule(hwAttrs->baseAddr);
    MAP_UART_enableInterrupt(hwAttrs->baseAddr, EUSCI_A_UART_RECEIVE_INTERRUPT);

    DebugP_log3("UART:(%p) CPU freq: %d; UART baudRate to %d", hwAttrs->baseAddr,
        inputClkFreq, object->baudRate);
}

/*
 *  ======== perfChangeNotifyFxn ========
 *
 *  Called by Power module before and after performance level is changed.
 */
static int perfChangeNotifyFxn(unsigned int eventType, uintptr_t eventArg,
    uintptr_t clientArg)
{
    uint32_t                  clockFreq;
    PowerMSP432_Freqs         powerFreqs;
    UARTMSP432_Object        *object = ((UART_Handle) clientArg)->object;
    UARTMSP432_HWAttrs const *hwAttrs = ((UART_Handle) clientArg)->hwAttrs;

    if (eventType == PowerMSP432_START_CHANGE_PERF_LEVEL) {
        /* Disable peripheral before performance level change */
        MAP_UART_disableModule(hwAttrs->baseAddr);
    }
    else { /* eventType == PowerMSP432_DONE_CHANGE_PERF_LEVEL */
        /* Get new performance level clock frequencies */
        PowerMSP432_getFreqs((unsigned int) eventArg, &powerFreqs);
        clockFreq = (hwAttrs->clockSource == EUSCI_A_UART_CLOCKSOURCE_SMCLK) ?
            powerFreqs.SMCLK : powerFreqs.ACLK;

        /* Reconfigure UART peripheral */
        initHw(object, hwAttrs, clockFreq);
    }

    return (Power_NOTIFYDONE);
}

/*
 *  ======== readBlockingTimeout ========
 */
static void readBlockingTimeout(uintptr_t arg)
{
    UARTMSP432_Object *object = ((UART_Handle)arg)->object;

    object->state.bufTimeout = true;
    SemaphoreP_postFromClock(object->readSem);
}

/*
 *  ======== readIsrBinaryBlocking ========
 *  Function that is called by the ISR
 */
static bool readIsrBinaryBlocking(UART_Handle handle)
{
    int                       readIn;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    readIn = MAP_UART_receiveData(hwAttrs->baseAddr);

    if (RingBuf_put(&object->ringBuffer, (unsigned char) readIn) == -1) {
        DebugP_log1("UART:(%p) Ring buffer full!!", hwAttrs->baseAddr);
        return (false);
    }
    DebugP_log2("UART:(%p) buffered '0x%02x'", hwAttrs->baseAddr,
        (unsigned char) readIn);

    if (object->state.callCallback) {
        object->state.callCallback = false;
        object->readCallback(handle, NULL, 0);
    }
    return (true);
}

/*
 *  ======== readIsrBinaryCallback ========
 */
static bool readIsrBinaryCallback(UART_Handle handle)
{
    int                       readIn;
    bool                      ret = true;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    readIn = MAP_UART_receiveData(hwAttrs->baseAddr);

    if (RingBuf_put(&object->ringBuffer, (unsigned char)readIn) == -1) {
        DebugP_log1("UART:(%p) Ring buffer full!!", hwAttrs->baseAddr);
        ret = false;
    }
    DebugP_log2("UART:(%p) buffered '0x%02x'", hwAttrs->baseAddr,
        (unsigned char) readIn);

    /*
     * Check and see if a UART_read in callback mode told use to continue
     * servicing the user buffer...
     */
    if (object->state.drainByISR) {
        readTaskCallback(handle);
    }

    return (ret);
}

/*
 *  ======== readIsrTextBlocking ========
 *  Function that is called by the ISR
 */
static bool readIsrTextBlocking(UART_Handle handle)
{
    int                       readIn;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    readIn = MAP_UART_receiveData(hwAttrs->baseAddr);

    if (readIn == '\r') {
        /* Echo character if enabled. */
        if (object->state.readEcho) {
            MAP_UART_transmitData(hwAttrs->baseAddr, '\r');
        }
        readIn = '\n';
    }

    if (RingBuf_put(&object->ringBuffer, (unsigned char) readIn) == -1) {
        DebugP_log1("UART:(%p) Ring buffer full!!", hwAttrs->baseAddr);
        return (false);
    }

    DebugP_log2("UART:(%p) buffered '0x%02x'", hwAttrs->baseAddr,
        (unsigned char) readIn);

    if (object->state.readEcho) {
        MAP_UART_transmitData(hwAttrs->baseAddr, (unsigned char) readIn);
    }
    if (object->state.callCallback) {
        object->state.callCallback = false;
        object->readCallback(handle, NULL, 0);
    }

    return (true);
}

/*
 *  ======== readIsrTextCallback ========
 */
static bool readIsrTextCallback(UART_Handle handle)
{
    int                       readIn;
    bool                      ret = true;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    readIn = MAP_UART_receiveData(hwAttrs->baseAddr);

    if (readIn == '\r') {
        /* Echo character if enabled. */
        if (object->state.readEcho) {
            /* Wait until TX is ready */
            while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
                EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG)) {}
            MAP_UART_transmitData(hwAttrs->baseAddr, '\r');
        }
        readIn = '\n';
    }
    if (RingBuf_put(&object->ringBuffer, (unsigned char) readIn) == -1) {
        DebugP_log1("UART:(%p) Ring buffer full!!", hwAttrs->baseAddr);
        ret = false;
    }
    DebugP_log2("UART:(%p) buffered '0x%02x'", hwAttrs->baseAddr,
        (unsigned char) readIn);

    if (object->state.readEcho) {
        /* Wait until TX is ready */
        while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
            EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG)) {}
        MAP_UART_transmitData(hwAttrs->baseAddr, (unsigned char)readIn);
    }

    /*
     * Check and see if a UART_read in callback mode told use to continue
     * servicing the user buffer...
     */
    if (object->state.drainByISR) {
        readTaskCallback(handle);
    }

    return (ret);
}

/*
 *  ======== readSemCallback ========
 *  Simple callback to post a semaphore for the blocking mode.
 */
static void readSemCallback(UART_Handle handle, void *buffer, size_t count)
{
    UARTMSP432_Object *object = handle->object;

    SemaphoreP_postFromISR(object->readSem);
}

/*
 *  ======== readTaskBlocking ========
 */
static int readTaskBlocking(UART_Handle handle)
{
    unsigned char      readIn;
    UARTMSP432_Object *object = handle->object;
    unsigned char     *buffer = object->readBuf;

    object->state.bufTimeout = false;
    SemaphoreP_pend(object->readSem, SemaphoreP_NO_WAIT);
    ClockP_start(object->timeoutClk, object->readTimeout);

    while (object->readCount) {
        if (RingBuf_get(&object->ringBuffer, &readIn) < 0) {
            object->state.callCallback = true;
            SemaphoreP_pend(object->readSem, SemaphoreP_WAIT_FOREVER);
            if (object->state.bufTimeout == true) {
                break;
            }
            RingBuf_get(&object->ringBuffer, &readIn);
        }

        DebugP_log2("UART:(%p) read '0x%02x'",
            ((UARTMSP432_HWAttrs const *) (handle->hwAttrs))->baseAddr,
            (unsigned char)readIn);

        *buffer = readIn;
        buffer++;
        /* In blocking mode, readCount doesn't not need a lock */
        object->readCount--;

        if (object->state.readDataMode == UART_DATA_TEXT &&
                object->state.readReturnMode == UART_RETURN_NEWLINE &&
                readIn == '\n') {
            break;
        }
    }

    ClockP_stop(object->timeoutClk);
    return (object->readSize - object->readCount);
}

/*
 *  ======== readTaskCallback ========
 *  This function is called the first time by the UART_read task and tries to
 *  get all the data it can get from the ringBuffer. If it finished, it will
 *  perform the user supplied callback. If it didn't finish, the ISR must handle
 *  the remaining data. By setting the drainByISR flag, the UART_read function
 *  handed over the responsibility to get the remaining data to the ISR.
 */
static int readTaskCallback(UART_Handle handle)
{
    bool               makeCallback = false;
    unsigned char      readIn;
    unsigned char     *bufferEnd;
    uintptr_t          key;
    UARTMSP432_Object *object = handle->object;

    object->state.drainByISR = false;
    bufferEnd = (unsigned char*) object->readBuf + object->readSize;

    while (object->readCount) {
        if (RingBuf_get(&object->ringBuffer, &readIn) < 0) {
            break;
        }

        DebugP_log2("UART:(%p) read '0x%02x'",
            ((UARTMSP432_HWAttrs const *)(handle->hwAttrs))->baseAddr,
            (unsigned char) readIn);

        *(unsigned char *) (bufferEnd - object->readCount *
            sizeof(unsigned char)) = readIn;

        key = HwiP_disable();

        object->readCount--;

        HwiP_restore(key);

        if (object->state.readDataMode == UART_DATA_TEXT &&
                object->state.readReturnMode == UART_RETURN_NEWLINE &&
                readIn == '\n') {
            makeCallback = true;
            break;
        }
    }

    if (!object->readCount || makeCallback) {
        /* Nested UART_reads from within callbacks are NOT supported!!! */
        object->readCallback(handle, object->readBuf,
            object->readSize - object->readCount);
        object->readSize = 0;
    }
    else {
        object->state.drainByISR = true;
    }

    return (0);
}

/*
 *  ======== writeData ========
 */
static void writeData(UART_Handle handle)
{
    unsigned char            *writePtr;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    if (object->writeCount) {
        writePtr = (unsigned char*) object->writeBuf + object->writeSize -
            object->writeCount;

        /* If mode is TEXT process the characters */
        if (object->state.writeDataMode == UART_DATA_TEXT) {
            if (object->state.writeCR) {
                MAP_UART_transmitData(hwAttrs->baseAddr, '\r');
                object->writeCount--;
                object->state.writeCR = false;
                DebugP_log2("UART:(%p) Wrote 0x%x", hwAttrs->baseAddr, '\r');
            }
            else {
                /* Add a return if next character is a newline. */
                MAP_UART_transmitData(hwAttrs->baseAddr, *writePtr);
                if (*writePtr != '\n') {
                    object->writeCount--;
                }
                else {
                    object->state.writeCR = true;
                }
                DebugP_log2("UART:(%p) Wrote 0x%x", hwAttrs->baseAddr, *writePtr);
            }
        }
        else {
            MAP_UART_transmitData(hwAttrs->baseAddr, *writePtr);
            object->writeCount--;
            DebugP_log2("UART:(%p) Wrote 0x%x", hwAttrs->baseAddr, *writePtr);
        }

        if (!object->writeCount) {
            MAP_UART_disableInterrupt(hwAttrs->baseAddr,
                EUSCI_A_UART_TRANSMIT_INTERRUPT);
            Power_releaseConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
            Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
            object->writeCallback(handle, (void *) object->writeBuf,
                object->writeSize);
        }
    }
}

/*
 *  ======== writeSemCallback ========
 *  Simple callback to post a semaphore for the blocking mode.
 */
static void writeSemCallback(UART_Handle handle, void *buffer, size_t count)
{
    UARTMSP432_Object *object = handle->object;

    SemaphoreP_postFromISR(object->writeSem);
}

/*
 *  ======== UARTMSP432_close ========
 */
void UARTMSP432_close(UART_Handle handle)
{
    unsigned int              i;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    MAP_UART_disableInterrupt(hwAttrs->baseAddr,
        EUSCI_A_UART_RECEIVE_INTERRUPT | EUSCI_A_UART_TRANSMIT_INTERRUPT);
    MAP_UART_disableInterrupt(hwAttrs->baseAddr,
        EUSCI_A_UART_RECEIVE_ERRONEOUSCHAR_INTERRUPT |
        EUSCI_A_UART_BREAKCHAR_INTERRUPT);
    MAP_UART_disableModule(hwAttrs->baseAddr);

    if (object->hwiHandle) {
        HwiP_delete(object->hwiHandle);
    }
    if (object->writeSem) {
        SemaphoreP_delete(object->writeSem);
    }
    if (object->readSem) {
        SemaphoreP_delete(object->readSem);
    }

    /* Remove power constraints */
    for (i = 0; object->perfConstraintMask; i++) {
        if (object->perfConstraintMask & 0x01) {
            Power_releaseConstraint(PowerMSP432_DISALLOW_PERFLEVEL_0 + i);
        }
        object->perfConstraintMask >>= 1;
    }
    if (object->state.rxEnabled) {
        Power_releaseConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
        Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
    }
    Power_releaseConstraint(PowerMSP432_DISALLOW_SHUTDOWN_0);
    Power_releaseConstraint(PowerMSP432_DISALLOW_SHUTDOWN_1);
    Power_unregisterNotify(&object->perfChangeNotify);

    object->state.opened = false;

    DebugP_log1("UART:(%p) closed", hwAttrs->baseAddr);
}

/*
 *  ======== UARTMSP432_control ========
 *  @pre    Function assumes that the handle is not NULL
 */
int UARTMSP432_control(UART_Handle handle, unsigned int cmd, void *arg)
{
    int                       bufferCount;
    unsigned char             data;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    bufferCount = RingBuf_peek(&object->ringBuffer, &data);

    switch (cmd) {
        /* Common UART CMDs */
        case (UART_CMD_PEEK):
            *(int *)arg = (bufferCount) ? data : UART_ERROR;
            DebugP_log2("UART:(%p) UART_CMD_PEEK: %d", hwAttrs->baseAddr,
                *(uintptr_t*)arg);
            return (UART_STATUS_SUCCESS);

        case (UART_CMD_ISAVAILABLE):
            *(bool *)arg = (bufferCount != 0);
            DebugP_log2("UART:(%p) UART_CMD_ISAVAILABLE: %d", hwAttrs->baseAddr,
                *(uintptr_t*)arg);
            return (UART_STATUS_SUCCESS);

        case (UART_CMD_GETRXCOUNT):
            *(int *)arg = bufferCount;
            DebugP_log2("UART:(%p) UART_CMD_GETRXCOUNT: %d", hwAttrs->baseAddr,
                *(uintptr_t*)arg);
            return (UART_STATUS_SUCCESS);

        case (UART_CMD_RXENABLE):
            if (!object->state.rxEnabled) {
                /*
                 * Set power constraints to keep peripheral active receiving
                 * RX interrupts and prevent a performance level change.
                 */
                Power_setConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
                Power_setConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
                MAP_UART_enableInterrupt(hwAttrs->baseAddr,
                    EUSCI_A_UART_RECEIVE_INTERRUPT);
                object->state.rxEnabled = true;
                DebugP_log1("UART:(%p) UART_CMD_RXENABLE: Enabled",
                    hwAttrs->baseAddr);
                DebugP_log1("UART:(%p) UART_control set read power constraint",
                    hwAttrs->baseAddr);
                return (UART_STATUS_SUCCESS);
            }
            DebugP_log1("UART:(%p) UART_CMD_RXENABLE: Already enabled",
                hwAttrs->baseAddr);
            return (UART_STATUS_ERROR);

        case (UART_CMD_RXDISABLE):
            if (object->state.rxEnabled) {
                MAP_UART_disableInterrupt(hwAttrs->baseAddr,
                    EUSCI_A_UART_RECEIVE_INTERRUPT);
                /*
                 * Remove constraints, this will allow the device to enter
                 * LPM3 and higher as well as allow performance level changes
                 * by the application.
                 */
                Power_releaseConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
                Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
                object->state.rxEnabled = false;
                DebugP_log1("UART:(%p) UART_CMD_RXDISABLE: Disabled",
                    hwAttrs->baseAddr);
                DebugP_log1("UART:(%p) UART_control released read power "
                    "constraint", hwAttrs->baseAddr);
                return (UART_STATUS_SUCCESS);
            }
            DebugP_log1("UART:(%p) UART_CMD_RXDISABLE: Already disabled",
                hwAttrs->baseAddr);
            return (UART_STATUS_ERROR);

        default:
            DebugP_log2("UART:(%p) UART CMD undefined: %d",
                hwAttrs->baseAddr, cmd);
            return (UART_STATUS_UNDEFINEDCMD);
    }
}

/*
 *  ======== UARTMSP432_hwiIntFxn ========
 *  Hwi function that processes UART interrupts.
 *
 *  @param(arg)         The UART_Handle for this Hwi.
 */
void UARTMSP432_hwiIntFxn(uintptr_t arg)
{
    bool                      readSuccess = true;
    uint8_t                   status;
    uintptr_t                 errorFlags;
    UARTMSP432_Object        *object = ((UART_Handle) arg)->object;
    UARTMSP432_HWAttrs const *hwAttrs = ((UART_Handle) arg)->hwAttrs;

    /* Clear interrupts */
    status = MAP_UART_getEnabledInterruptStatus(hwAttrs->baseAddr);
    MAP_UART_clearInterruptFlag(hwAttrs->baseAddr, status);

    if (status & EUSCI_A_UART_RECEIVE_INTERRUPT_FLAG) {
        readSuccess = object->readFxns.readIsrFxn((UART_Handle)arg);
    }

    if (status & EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG) {
        writeData((UART_Handle)arg);
    }

    if (status & (EUSCI_A_UART_RECEIVE_ERRONEOUSCHAR_INTERRUPT |
        EUSCI_A_UART_BREAKCHAR_INTERRUPT) || !readSuccess) {

        errorFlags = MAP_UART_queryStatusFlags(hwAttrs->baseAddr,
            EUSCI_A_UART_OVERRUN_ERROR | EUSCI_A_UART_BREAK_DETECT |
            EUSCI_A_UART_PARITY_ERROR | EUSCI_A_UART_FRAMING_ERROR);

        errorCallback((UART_Handle)arg, errorFlags);
    }
}

/*
 *  ======== UARTMSP432_init ========
 */
void UARTMSP432_init(UART_Handle handle)
{
    UARTMSP432_Object *object = handle->object;

    object->state.opened = false;
}

/*
 *  ======== UARTMSP432_open ========
 */
UART_Handle UARTMSP432_open(UART_Handle handle, UART_Params *params)
{
    unsigned int              i;
    uintptr_t                 key;
    uint32_t                  clockFreq;
    uint8_t                   numPerfLevels;
    int32_t                   baudrateIndex;
    union {
        ClockP_Params         clockParams;
        HwiP_Params           hwiParams;
        SemaphoreP_Params     semParams;
    } portsParams;
    PowerMSP432_Freqs         powerFreqs;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    if (params == NULL) {
        params = (UART_Params *) &UART_defaultParams;
    }

    /* Check that a callback is set */
    DebugP_assert((params->readMode != UART_MODE_CALLBACK) ||
        (params->readCallback != NULL));
    DebugP_assert((params->writeMode != UART_MODE_CALLBACK) ||
        (params->writeCallback != NULL));

    key = HwiP_disable();

    if (object->state.opened) {
        HwiP_restore(key);
        DebugP_log1("UART:(%p) already in use.", hwAttrs->baseAddr);
        return (NULL);
    }
    object->state.opened = true;

    HwiP_restore(key);

    /* Ensure a supported clock source is used */
    if (hwAttrs->clockSource != EUSCI_A_UART_CLOCKSOURCE_ACLK &&
        hwAttrs->clockSource != EUSCI_A_UART_CLOCKSOURCE_SMCLK) {
        DebugP_log1("UART:(%p) Error! Using unsupported clock source.",
            hwAttrs->baseAddr);
        object->state.opened = false;
        return (NULL);
    }

    /*
     * Add power management support - Disable performance transitions while
     * opening the driver is open.  This constraint remains active until a
     * UART_control() disables receive interrupts.  Afterwards performance
     * levels can be changed by the application.  A UART_control() call can
     * enable RX interrupts again and set the pertinent constraints.
     */
    Power_setConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);

    /*
     * Verify that the driver can be opened at current performance level and
     * set constraints for other performance levels.
     */
    numPerfLevels = PowerMSP432_getNumPerfLevels();
    PowerMSP432_getFreqs(Power_getPerformanceLevel(), &powerFreqs);
    if (hwAttrs->clockSource == EUSCI_A_UART_CLOCKSOURCE_ACLK) {
        /*
         * Verify if driver can be opened with ACLK; ACLK does not change
         * in any performance level.
         */
        baudrateIndex = findBaudDividerIndex(hwAttrs->baudrateLUT,
            hwAttrs->numBaudrateEntries, params->baudRate, powerFreqs.ACLK);
        if (baudrateIndex == -1) {
            DebugP_log3("UART:(%p) unable to find a valid buadrate %d "
                "configuration at clock input clock freq %d", hwAttrs->baseAddr,
                params->baudRate, powerFreqs.ACLK);
            Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
            object->state.opened = false;
            return (NULL);
        }
        clockFreq = powerFreqs.ACLK;
    }
    else {    /* hwAttrs->clockSource == EUSCI_A_UART_CLOCKSOURCE_SMCLK */
        baudrateIndex = findBaudDividerIndex(hwAttrs->baudrateLUT,
            hwAttrs->numBaudrateEntries, params->baudRate, powerFreqs.SMCLK);
        if (baudrateIndex == -1) {
            DebugP_log3("UART:(%p) unable to find a valid buadrate %d "
                "configuration at clock input clock freq %d", hwAttrs->baseAddr,
                params->baudRate, powerFreqs.SMCLK);
            Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);
            object->state.opened = false;
            return (NULL);
        }
        clockFreq = powerFreqs.SMCLK;

        /*
         * SMCLK changes with performance levels.  Set constraints for
         * unsupported performance levels.
         */
        for (i = 0; i < numPerfLevels; i++) {
            PowerMSP432_getFreqs(i, &powerFreqs);
            baudrateIndex = findBaudDividerIndex(hwAttrs->baudrateLUT,
                hwAttrs->numBaudrateEntries, params->baudRate, powerFreqs.SMCLK);
            if (baudrateIndex == -1) {
                /* Set constraint and keep track of it in perfConstraintMask */
                object->perfConstraintMask |= (1 << i);
                Power_setConstraint(PowerMSP432_DISALLOW_PERFLEVEL_0 + i);
            }
        }
    }

    /*
     * Shutdown not supported while driver is open.  The DEEPSLEEP_0 constraint
     * keeps stops the device from going into LPM3 or higher.  This is done
     * to keep the UART peripheral receiving in the background and storing data
     * in the internal ring buff.
     */
    Power_setConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
    Power_setConstraint(PowerMSP432_DISALLOW_SHUTDOWN_0);
    Power_setConstraint(PowerMSP432_DISALLOW_SHUTDOWN_1);

    /* Register function to reconfigure peripheral on perf level changes */
    Power_registerNotify(&object->perfChangeNotify,
        PowerMSP432_START_CHANGE_PERF_LEVEL | PowerMSP432_DONE_CHANGE_PERF_LEVEL,
        perfChangeNotifyFxn, (uintptr_t) handle);

    /* Create the Hwi for this UART peripheral */
    HwiP_Params_init(&(portsParams.hwiParams));
    portsParams.hwiParams.arg = (uintptr_t) handle;
    portsParams.hwiParams.priority = hwAttrs->intPriority;
    object->hwiHandle = HwiP_create(hwAttrs->intNum, UARTMSP432_hwiIntFxn,
        &(portsParams.hwiParams));
    if (object->hwiHandle == NULL) {
        DebugP_log1("UART:(%p) HwiP_create() failed", hwAttrs->baseAddr);
        UARTMSP432_close(handle);
        return (NULL);
    }

    SemaphoreP_Params_init(&(portsParams.semParams));
    portsParams.semParams.mode = SemaphoreP_Mode_BINARY;

    if (params->writeMode == UART_MODE_BLOCKING) {
        /* If write mode is blocking create a semaphore and set callback. */
        object->writeSem = SemaphoreP_create(0, &(portsParams.semParams));
        if (object->writeSem == NULL) {
            DebugP_log1("UART:(%p) SemaphoreP_create() failed.",
                hwAttrs->baseAddr);
            UARTMSP432_close(handle);
            return (NULL);
        }
        object->writeCallback = &writeSemCallback;
    }
    else {
        /* UART_MODE_CALLBACK - Store application callback */
        object->writeCallback = params->writeCallback;
    }

    if (params->readMode == UART_MODE_BLOCKING) {
        /* If read mode is blocking create a semaphore and set callback. */
        object->readSem = SemaphoreP_create(0, &(portsParams.semParams));
        if (object->readSem == NULL) {
            DebugP_log1("UART:(%p) SemaphoreP_create() failed.",
                hwAttrs->baseAddr);
            UARTMSP432_close(handle);
            return (NULL);
        }
        object->readCallback = &readSemCallback;

        ClockP_Params_init(&(portsParams.clockParams));
        portsParams.clockParams.arg = (uintptr_t) handle;
        object->timeoutClk = ClockP_create((ClockP_Fxn) &readBlockingTimeout,
            &(portsParams.clockParams));
        if (object->timeoutClk == NULL) {
            DebugP_log1("UART:(%p) ClockP_create() failed.", hwAttrs->baseAddr);
            UARTMSP432_close(handle);
            return (NULL);
        }
    }
    else {
        object->state.drainByISR = false;
        object->readCallback = params->readCallback;
    }

    /*
     * Initialize UART read buffer - will store received bytes until
     * UART_read is invoked.
     */
    RingBuf_construct(&object->ringBuffer, hwAttrs->ringBufPtr,
        hwAttrs->ringBufSize);
    /*
     * Store UART parameters & initialize peripheral.  These are used to
     * re/initialize the peripheral when opened or changing performance level.
     */
    object->state.readMode       = params->readMode;
    object->state.writeMode      = params->writeMode;
    object->state.readReturnMode = params->readReturnMode;
    object->state.readDataMode   = params->readDataMode;
    object->state.writeDataMode  = params->writeDataMode;
    object->state.readEcho       = params->readEcho;
    object->readTimeout          = params->readTimeout;
    object->writeTimeout         = params->writeTimeout;
    object->baudRate             = params->baudRate;
    object->stopBits             = params->stopBits;
    object->parityType           = params->parityType;
    object->readFxns =
        staticFxnTable[object->state.readMode][object->state.readDataMode];
    object->writeBuf             = NULL;
    object->readBuf              = NULL;
    object->writeCount           = 0;
    object->readCount            = 0;
    object->writeSize            = 0;
    object->readSize             = 0;
    object->state.writeCR        = false;
    object->state.txEnabled      = false;
    object->state.rxEnabled      = true;
    initHw(object, hwAttrs, clockFreq);

    DebugP_log1("UART:(%p) opened", hwAttrs->baseAddr);

    /* Return the handle */
    return (handle);
}

/*
 *  ======== UARTMSP432_read ========
 */
int UARTMSP432_read(UART_Handle handle, void *buffer, size_t size)
{
    uintptr_t          key;
    UARTMSP432_Object *object = handle->object;

    key = HwiP_disable();

    if ((object->state.readMode == UART_MODE_CALLBACK) && object->readSize) {
        HwiP_restore(key);

        DebugP_log1("UART:(%p) Could not read data, uart in use.",
            ((UARTMSP432_HWAttrs const *)(handle->hwAttrs))->baseAddr);
        return (UART_ERROR);
    }

    /* Save the data to be read and restore interrupts. */
    object->readBuf = buffer;
    object->readSize = size;
    object->readCount = size;

    HwiP_restore(key);

    return (object->readFxns.readTaskFxn(handle));
}

/*
 *  ======== UARTMSP432_readCancel ========
 */
void UARTMSP432_readCancel(UART_Handle handle)
{
    uintptr_t          key;
    UARTMSP432_Object *object = handle->object;

    if ((object->state.readMode != UART_MODE_CALLBACK) ||
        (object->readSize == 0)) {
        return;
    }

    key = HwiP_disable();

    object->state.drainByISR = false;
    /*
     * Indicate that what we've currently received is what we asked for so that
     * the existing logic handles the completion.
     */
    object->readSize -= object->readCount;
    object->readCount = 0;

    HwiP_restore(key);

    object->readFxns.readTaskFxn(handle);
}

/*
 *  ======== UARTMSP432_readPolling ========
 */
int UARTMSP432_readPolling(UART_Handle handle, void *buf, size_t size)
{
    int32_t                   count = 0;
    unsigned char            *buffer = (unsigned char *)buf;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    /* Read characters. */
    while (size) {
        /* Grab data from the RingBuf before getting it from the RX data reg */
        MAP_UART_disableInterrupt(hwAttrs->baseAddr,
            EUSCI_A_UART_RECEIVE_INTERRUPT);
        if (RingBuf_get(&object->ringBuffer, buffer) == -1) {
            /* RX interrupts are disabled; driverlib will poll for us */
            *buffer = MAP_UART_receiveData(hwAttrs->baseAddr);
        }
        if (object->state.rxEnabled) {
            MAP_UART_enableInterrupt(hwAttrs->baseAddr,
                EUSCI_A_UART_RECEIVE_INTERRUPT);
        }

        DebugP_log2("UART:(%p) Read character 0x%x", hwAttrs->baseAddr,
            *buffer);
        count++;
        size--;

        if (object->state.readDataMode == UART_DATA_TEXT && *buffer == '\r') {
            /* Echo character if enabled. */
            if (object->state.readEcho) {
                while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
                    EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
                MAP_UART_transmitData(hwAttrs->baseAddr,  '\r');
            }
            *buffer = '\n';
        }

        /* Echo character if enabled. */
        if (object->state.readDataMode == UART_DATA_TEXT &&
                object->state.readEcho) {
            while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
                EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
            MAP_UART_transmitData(hwAttrs->baseAddr,  *buffer);
        }

        /* If read return mode is newline, finish if a newline was received. */
        if (object->state.readDataMode == UART_DATA_TEXT &&
                object->state.readReturnMode == UART_RETURN_NEWLINE &&
                *buffer == '\n') {
            return (count);
        }

        buffer++;
    }

    DebugP_log2("UART:(%p) Read polling finished, %d bytes read",
        hwAttrs->baseAddr, count);

    return (count);
}

/*
 *  ======== UARTMSP432_write ========
 */
int UARTMSP432_write(UART_Handle handle, const void *buffer, size_t size)
{
    uintptr_t                 key;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    if (!size) {
        return 0;
    }

    key = HwiP_disable();

    if (object->writeCount) {
        HwiP_restore(key);
        DebugP_log1("UART:(%p) Could not write data, uart in use.",
            hwAttrs->baseAddr);

        return (UART_ERROR);
    }

    /* Save the data to be written and restore interrupts. */
    object->writeBuf = buffer;
    object->writeSize = size;
    object->writeCount = size;

    HwiP_restore(key);

    /*
     * Set power constraint to keep peripheral active during transfer and
     * to prevent a performance level change
     */
    Power_setConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
    Power_setConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);

    /* Enabling TX interrupt will trigger the Hwi which will handle the write */
    MAP_UART_enableInterrupt(hwAttrs->baseAddr, EUSCI_A_UART_TRANSMIT_INTERRUPT);

    /* If writeMode is blocking, block and get the state. */
    if (object->state.writeMode == UART_MODE_BLOCKING) {
        /* Pend on semaphore and wait for Hwi to finish. */
        if (SemaphoreP_pend(object->writeSem, object->writeTimeout) !=
                SemaphoreP_OK) {
            /* Semaphore timed out, make the write empty and log the write. */
            MAP_UART_disableInterrupt(hwAttrs->baseAddr,
                EUSCI_A_UART_TRANSMIT_INTERRUPT);
            object->writeCount = 0;

            DebugP_log2("UART:(%p) Write timed out, %d bytes written",
                hwAttrs->baseAddr, object->writeCount);
        }
        return (object->writeSize - object->writeCount);
    }

    return (0);
}

/*
 *  ======== UARTMSP432_writeCancel ========
 */
void UARTMSP432_writeCancel(UART_Handle handle)
{
    uintptr_t                 key;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;
    unsigned int              written;

    key = HwiP_disable();

    /* Return if there is no write. */
    if (!object->writeCount) {
        HwiP_restore(key);
        return;
    }

    /* Set size = 0 to prevent writing and restore interrupts. */
    MAP_UART_disableInterrupt(hwAttrs->baseAddr, EUSCI_A_UART_TRANSMIT_INTERRUPT);
    written = object->writeCount;
    object->writeCount = 0;

    HwiP_restore(key);

    /* Remove constraints set during write */
    Power_releaseConstraint(PowerMSP432_DISALLOW_DEEPSLEEP_0);
    Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);

    /* Reset the write buffer so we can pass it back */
    object->writeCallback(handle, (void *)object->writeBuf,
        object->writeSize - written);

    DebugP_log2("UART:(%p) Write canceled, %d bytes written",
        hwAttrs->baseAddr, object->writeSize - written);
}

/*
 *  ======== UARTMSP432_writePolling ========
 */
int UARTMSP432_writePolling(UART_Handle handle, const void *buf, size_t size)
{
    int32_t                   count = 0;
    unsigned char            *buffer = (unsigned char *)buf;
    UARTMSP432_Object        *object = handle->object;
    UARTMSP432_HWAttrs const *hwAttrs = handle->hwAttrs;

    /* Set power constraint to prevent a performance level change. */
    Power_setConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);

    /* Write characters. */
    while (size) {
        if (object->state.writeDataMode == UART_DATA_TEXT && *buffer == '\n') {
            /* Wait until we can TX a byte */
            while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
                EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
            MAP_UART_transmitData(hwAttrs->baseAddr,  '\r');
            count++;
        }
        /* Wait until we can TX a byte */
        while (!MAP_UART_getInterruptStatus(hwAttrs->baseAddr,
            EUSCI_A_UART_TRANSMIT_INTERRUPT_FLAG));
        MAP_UART_transmitData(hwAttrs->baseAddr,  *buffer);

        DebugP_log2("UART:(%p) Wrote character 0x%x", hwAttrs->baseAddr,
            *buffer);
        buffer++;
        count++;
        size--;
    }

    Power_releaseConstraint(PowerMSP432_DISALLOW_PERF_CHANGES);

    DebugP_log2("UART:(%p) Write polling finished, %d bytes written",
        hwAttrs->baseAddr, count);

    return (count);
}
