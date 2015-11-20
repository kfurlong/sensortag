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
/*
 *  ======== UART.xdc ========
 */
package ti.drivers;
import xdc.rov.ViewInfo;

/*!
 *  ======== UART ========
 */
@NoRuntime
@HeaderName("")
module UART {

    /*!
     *  ======== LibType ========
     *  UART library selection options
     *
     *  This enumeration defines all the UART library type
     *  provided by the product.  You can select the library type by setting
     *  the {@link #libType UART.libType} configuration parameter.
     *
     *  @field(LibType_Instrumented) The library supplied is prebuilt with
     *  logging and assertions enabled.
     *
     *  @field(LibType_NonInstrumented) The library supplied is prebuilt
     *  with logging and assertions disabled.
     */
    enum LibType {
        LibType_Instrumented,           /*! instrumented */
        LibType_NonInstrumented         /*! non-instrumented */
    };

    /*!
     *  ======== libType ========
     *  UART Library type
     *
     *  Deprecated: Please use ti.tirtos.TIRTOS.libType instead.
     *
     *  The UART runtime is provided in the form of a library that is
     *  linked with your application.  Several forms of this library are
     *  provided with the UART product. This configuration parameter
     *  allows you to select the form of UART to use.
     *
     *  The default value of libType is
     *  {@link #LibType_Instrumented UART_LibType_Instrumented}.  For a
     *  complete list of options and what they offer see {@link #LibType}.
     */
    metaonly config LibType libType = LibType_Instrumented;

    /*!
     *  @_nodoc
     *  ======== UART_Config ========
     *  Structure must match the UART_Config structure defined in UART.h
     */
    struct UART_Config {
        Void               *fxnTablePtr; //Used to determine the implementation
        Void               *object;      //Used to access the data
        Void               *hwAttrs;     //Used to get the attributes
    };

    /*!
     *  @_nodoc
     *  ======== UART callback ========
     *  Copied from UART.h and must match.
     */
    typedef Void (*CallbackFxn)(Ptr, Int);

    /*!
     *  @_nodoc
     *  ======== UART_Mode ========
     *  Copied from UART.h and must match.
     */
    enum UART_Mode {
        UART_MODE_BLOCKING,
        UART_MODE_CALLBACK,
        UART_MODE_ISSUERECLAIM
    };

    /*!
     *  @_nodoc
     *  ======== UART_ReturnMode ========
     *  Copied from UART.h and must match.
     */
    enum UART_ReturnMode {
        UART_RETURN_FULL,
        UART_RETURN_NEWLINE
    };

    /*!
     *  @_nodoc
     *  ======== UART_DataMode ========
     *  Copied from UART.h and must match.
     */
    enum UART_DataMode {
        UART_DATA_BINARY,
        UART_DATA_TEXT
    };

    /*!
     *  @_nodoc
     *  ======== UART_Echo ========
     *  Copied from UART.h and must match.
     */
    enum UART_Echo {
        UART_ECHO_OFF = 0,
        UART_ECHO_ON = 1
    };

    /*!
     *  @_nodoc
     *  ======== UART_LEN ========
     *  Copied from UART.h and must match.
     *
     *  Enum is set to *Ware defines, can not be used in ROV
     */
     enum UART_LEN {
        UART_LEN_5,
        UART_LEN_6,
        UART_LEN_7,
        UART_LEN_8
    };

    /*!
     *  @_nodoc
     *  ======== UART_STOP ========
     *  Copied from UART.h and must match.
     *
     *  Enum is set to *Ware defines, can not be used in ROV
     */
    enum UART_STOP{
        UART_STOP_ONE,
        UART_STOP_TWO
    };

    /*!
     *  @_nodoc
     *  ======== UART_PAR ========
     *  Copied from UART.h and must match.
     *
     *  Enum is set to *Ware defines, can not be used in ROV
     */
    enum UART_PAR {
        UART_PAR_NONE,
        UART_PAR_EVEN,
        UART_PAR_ODD,
        UART_PAR_ZERO,
        UART_PAR_ONE
    };

    /*!
     *  @_nodoc
     *  ======== UARTTiva_hwAttrs ========
     *  Structure must match the UART_HWAttrs structure defined in
     *  uart/UARTTiva.h
     */
    struct UARTTiva_HWAttrs {
        unsigned int baseAddr;
        unsigned int intNum;
    };


    /*!
     *  @_nodoc
     *  ======== UARTTivaDMA_hwAttrs ========
     *  Structure must match the UARTTivaDMA_HWAttrs structure defined in
     *  uart/UARTTivaDMA.h
     */
    struct UARTTivaDMA_HWAttrs {
        unsigned int baseAddr;
        unsigned int intNum;
        unsigned long rxChannelIndex;
        unsigned long txChannelIndex;
    };
    /*!
     *  @_nodoc
     *  ======== UART_Object ========
     *  Copied from UART.h and must match.
     */
    struct UARTTiva_Object {
        Bool                isOpen;

        UART_Mode           readMode;
        UART_Mode           writeMode;
        unsigned int        readTimeout;
        unsigned int        writeTimeout;
        CallbackFxn         readCallback;
        CallbackFxn         writeCallback;
        UART_ReturnMode     readReturnMode;
        UART_DataMode       readDataMode;
        UART_DataMode       writeDataMode;
        UART_Echo           readEcho;

        const void         *writeBuf;
        size_t              writeCount;
        size_t              writeSize;
        Bool                writeCR;

        void               *readBuf;
        size_t              readCount;
        size_t              readSize;

        /* Stuff beyond here is ignored */
        //Hwi.Object          hwi;
        //Semaphore.Object    writeSem;
        //Semaphore.Object    readSem;
    };

    /*!
     *  @_nodoc
     *  ======== UARTCC3200_hwAttrs ========
     *  Structure must match the UART_HWAttrs structure defined in
     *  uart/UARTCC3200.h
     */
    struct UARTCC3200_HWAttrs {
        unsigned int baseAddr;
        unsigned int intNum;
    };

    /*!
     *  @_nodoc
     *  ======== UARTCC3200DMA_hwAttrs ========
     *  Structure must match the UARTCC3200DMA_HWAttrs structure defined in
     *  uart/UARTCC3200DMA.h
     */
    struct UARTCC3200DMA_HWAttrs {
        unsigned int baseAddr;
        unsigned int intNum;
        unsigned long rxChannelIndex;
        unsigned long txChannelIndex;
    };

    /*!
     *  @_nodoc
     *  ======== UARTCC3200_Object ========
     *  Structure must match the UART_Object structure defined in
     *  uart/UARTCC3200.h
     */
    struct UARTCC3200_Object {
        Bool                isOpen;

        UART_Mode           readMode;
        UART_Mode           writeMode;
        unsigned int        readTimeout;
        unsigned int        writeTimeout;
        CallbackFxn         readCallback;
        CallbackFxn         writeCallback;
        UART_ReturnMode     readReturnMode;
        UART_DataMode       readDataMode;
        UART_DataMode       writeDataMode;
        UART_Echo           readEcho;

        const void         *writeBuf;
        size_t              writeCount;
        size_t              writeSize;
        Bool                writeCR;

        void               *readBuf;
        size_t              readCount;
        size_t              readSize;
    };

    struct UARTTivaDMA_Object {
        bool                 opened;
        UART_Mode            readMode;
        UART_Mode            writeMode;
        unsigned int         readTimeout;
        unsigned int         writeTimeout;
        CallbackFxn          readCallback;
        CallbackFxn          writeCallback;
        UART_ReturnMode      readReturnMode;
        UART_DataMode        readDataMode;
        UART_DataMode        writeDataMode;
        UART_Echo            readEcho;

        const void          *writeBuf;
        size_t               writeCount;
        size_t               writeSize;

        void                *readBuf;
        size_t               readCount;
        size_t               readSize;

        // The rest of the structure is ignored.
    };

    /*!
     *  @_nodoc
     *  ======== UARTCC3200DMA_Object ========
     *  Structure must match the UART_Object structure defined in
     *  uart/UARTCC3200DMA.h (at least the first part, semaphore
     *  handles and lists are left out).
     */
    struct UARTCC3200DMA_Object {
        bool                 opened;
        UART_Mode            readMode;
        UART_Mode            writeMode;
        unsigned int         readTimeout;
        unsigned int         writeTimeout;
        CallbackFxn          readCallback;
        CallbackFxn          writeCallback;
        UART_ReturnMode      readReturnMode;
        UART_DataMode        readDataMode;
        UART_DataMode        writeDataMode;
        UART_Echo            readEcho;

        const void          *writeBuf;
        size_t               writeCount;
        size_t               writeSize;

        void                *readBuf;
        size_t               readCount;
        size_t               readSize;

        // This part is ignored.
        //SemaphoreP_Handle    writeSem;
        //SemaphoreP_Handle    readSem;

        //ListP_List           readActiveQueue;
        //ListP_List           readDoneQueue;
        //ListP_List           writeActiveQueue;
        //ListP_List           writeDoneQueue;
    };

    /*!
     *  @_nodoc
     *  ======== UARTUSCIA_HWAttrs ========
     *  Structure must match the UARTTiva_HWAttrs structure defined in
     *  uart/UARTUSCIA.h
     */
    struct UARTUSCIA_HWAttrs {
        unsigned int        baseAddr;
        Bits8               clockSouce;
        Bits32              bitOrder;
        unsigned int        numBaudrateEntries;
    };

    /*!
     *  @_nodoc
     *  ======== UARTUSCIA_Object ========
     *  Copied from UART.h and must match.
     */
    struct UARTUSCIA_Object {
        Bool                isOpen;
        UART_Mode           readMode;
        UART_Mode           writeMode;
        unsigned int        readTimeout;
        unsigned int        writeTimeout;
        CallbackFxn         readCallback;
        CallbackFxn         writeCallback;
        UART_ReturnMode     readReturnMode;
        UART_DataMode       readDataMode;
        UART_DataMode       writeDataMode;
        UART_Echo           readEcho;


        const Void         *writeBuf;
        size_t              writeCount;
        size_t              writeSize;
        Bool                writeCR;

        Void               *readBuf;
        size_t              readCount;
        size_t              readSize;

        /* Stuff beyond here is ignored */
        //Semaphore.Object    writeSem;
        //Semaphore.Object    readSem;
    };

    /*!
     *  @_nodoc
     *  ======== UARTEUSCIA_HWAttrs ========
     *  Structure must match the UARTTiva_HWAttrs structure defined in
     *  uart/UARTEUSCIA.h
     */
    struct UARTEUSCIA_HWAttrs {
        unsigned int        baseAddr;
        Bits8               clockSouce;
        Bits32              bitOrder;
        unsigned int        numBaudrateEntries;
    };

    /*!
     *  @_nodoc
     *  ======== UARTEUSCIA_Object ========
     *  Copied from UART.h and must match.
     */
    struct UARTEUSCIA_Object {
        Bool                isOpen;
        UART_Mode           readMode;
        UART_Mode           writeMode;
        unsigned int        readTimeout;
        unsigned int        writeTimeout;
        CallbackFxn         readCallback;
        CallbackFxn         writeCallback;
        UART_ReturnMode     readReturnMode;
        UART_DataMode       readDataMode;
        UART_DataMode       writeDataMode;
        UART_Echo           readEcho;


        const Void         *writeBuf;
        size_t              writeCount;
        size_t              writeSize;
        Bool                writeCR;

        Void               *readBuf;
        size_t              readCount;
        size_t              readSize;

        /* Stuff beyond here is ignored */
        //Semaphore.Object    writeSem;
        //Semaphore.Object    readSem;
    };

    /*!
     *  @_nodoc
     *  ======== UARTMSP432_HWAttrs ========
     *  Structure must match the UARTMSP432_HWAttrs structure defined in
     *  uart/UARTMSP432.h
     */
    struct UARTMSP432_HWAttrs {
        Bits32  baseAddr;
        Bits8   intNum;
        Bits8   clockSouce;
        Bits32  bitOrder;
        Bits8   numBaudrateEntries;
    };

    /*!
     *  @_nodoc
     *  ======== UARTMSP432_Object ========
     *  Copied from UARTMSP432.h and must match.
     */
    struct UARTMSP432_Object {
        UART_Mode        readMode;
        UART_Mode        writeMode;
        unsigned int     readTimeout;
        unsigned int     writeTimeout;
        CallbackFxn      readCallback;
        CallbackFxn      writeCallback;
        UART_ReturnMode  readReturnMode;
        UART_DataMode    readDataMode;
        UART_DataMode    writeDataMode;
        UART_Echo        readEcho;

        const Void      *writeBuf;
        size_t           writeCount;
        size_t           writeSize;
        Bool             writeCR;

        Void            *readBuf;
        size_t           readCount;
        size_t           readSize;

        Ptr              writeSem;
        Ptr              readSem;
        Bool             isOpen;
    };

    /*!
     *  @_nodoc
     *  ======== BasicView ========
     */
    metaonly struct BasicView {
        String uartHandle;
        String baseAddr;
        String functionTable;
    };

     /*!
     *  @_nodoc
     *  ======== ConfigView ========
     */
    metaonly struct ConfigView {
        String baseAddr;
        String writeMode;
        String readMode;
        String writeTimeout;
        String readTimeout;
        String readReturnMode;
        String readDataMode;
        String writeDataMode;
        String readEcho;
    };

    /*!
     *  @_nodoc
     *  ======== BufferView ========
     */
    metaonly struct BufferView {
        String Base;
        String Format;
        String Contents;
    };

    /*!
     *  @_nodoc
     *  ======== rovViewInfo ========
     */
    @Facet
    metaonly config ViewInfo.Instance rovViewInfo =
        ViewInfo.create({
            viewMap: [
                ['Basic',
                    {
                        type: ViewInfo.MODULE_DATA,
                        viewInitFxn: 'viewInitBasic',
                        structName: 'BasicView'
                    }
                ],
//                ['Config',
//                    {
//                        type: ViewInfo.MODULE_DATA,
//                        viewInitFxn: 'viewInitConfig',
//                        structName: 'ConfigView'
//                    }
//                ],
//                ['Write Buffer',
//                    {
//                        type: ViewInfo.MODULE_DATA,
//                        viewInitFxn: 'viewInitWriteBuffer',
//                        structName: 'BufferView'
//                    }
//                ],
//                ['Read Buffer',
//                    {
//                        type: ViewInfo.MODULE_DATA,
//                        viewInitFxn: 'viewInitReadBuffer',
//                        structName: 'BufferView'
//                    }
//                ],
            ]
        });
}
