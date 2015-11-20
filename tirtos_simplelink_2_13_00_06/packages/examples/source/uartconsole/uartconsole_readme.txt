Example Summary
---------------
Application that uses the UART driver and C stdio to implement a console. It
also demonstrates System Analyzer usage via a USB.

Peripherals Exercised
---------------------
Board_LED0      Indicates that the board was initialized within main()
Board_UART0     Connection to the host "console"
Board_USBDEVICE Used for logging via USB*

Resources & Jumper Settings
---------------------------
Please refer to the development board's specific "Settings and Resources"
section in the Getting Started Guide. For convenience, a short summary is also
shown below.

| Development board | Notes                                                  |
| ================= | ====================================================== |
| DK-TM4C123G       | Please ensure that the board is connected to your host |
| DK-TM4C129X       | via a USB cable. A VCOM (virtual COM) port driver may  |
| EK-TM4C123GXL     | need to be installed.                                  |
| EK-TM4C1294XL     |                                                        |
| MSP-EXP430F5529   |                                                        |
| MSP-EXP430F5529LP |                                                        |
| TMDXDOCK28M36     |                                                        |
| ----------------- | ------------------------------------------------------ |
| TMDXDOCKH52C1     | Please ensure that the board is connected to your host |
|                   | via a USB cable. A VCOM (virtual COM) port driver may  |
|                   | need to be installed.                                  |
|                   | Connectivity Bank 30-31: B-C position (USB)            |
| ----------------- | ------------------------------------------------------ |

Example Usage
-------------
Run the example. Board_LED0 turns ON to indicate TI-RTOS driver
initialization is complete.

When the application is running, open a serial session (e.g. HyperTerminal,
puTTY, etc.) to the appropriate COM port. Note: the COM port can be determined
via Device Manager in Windows or via ls /dev/tty* in Linux.

The connection should have the following settings
    Baudrate:     9600
    Data bits:       8
    Stop bits:       1
    Parity:       None
    Flow Control: None

The serial session is now a console to the target. You can get the load,
put a task to sleep or exit the console.

This example also demonstrates System Analyzer in CCS. This is accomplished
via sending out the logs records via USB from the target to the host.
Please refer to TI-RTOS User Guide's for more details.

Application Design Details
--------------------------
This application demonstrates how to use the TI-RTOS UART driver to implement
the C stdio, stdin, and stdout streams for reading and writing through a
UART. I/O via stdin and stdout will go through Board_UART0. Calls to
System_printf and System_abort will also be sent to the UART using SysCallback.
Log events will be sent during idle through Board_USBDEVICE and can be viewed
by System Analyzer.

The application assumes the PC terminal has no implicit CR or LF, does not
echo characters and sends only a CR when return/enter is typed.

To help fill up the logs, the kernel is configured to generate Log records
via the following from the .cfg file
    BIOS.logsEnabled = true;

The drivers by default are instrumented. So the following pulls in the
instrumented UART and GPIO libraries
    var GPIO = xdc.useModule('ti.drivers.GPIO');
    var UART = xdc.useModule('ti.drivers.UART');

Note: most of the other examples do not use instrumented libraries to improve
performance and minimize footprint.

For GNU and IAR users, please read the following website for details about
semi-hosting:
    http://processors.wiki.ti.com/index.php/TI-RTOS_Examples_SemiHosting
