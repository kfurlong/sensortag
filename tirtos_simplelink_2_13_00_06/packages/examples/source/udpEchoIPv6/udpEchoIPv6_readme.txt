Example Summary
---------------
This application demonstrates how to use UDP IPv6.

Peripherals Exercised
---------------------
Board_LED0      Indicates that the board was initialized within main()
Board_EMAC      Connection to network

Resources & Jumper Settings
---------------------------
Please refer to the development board's specific "Settings and Resources"
section in the Getting Started Guide. For convenience, a short summary is also
shown below.

| Development board | Notes                                                  |
| ================= | ====================================================== |
| DK-TM4C129X       | N/A                                                    |
| EK-TM4C1294XL     |                                                        |
| ----------------- | ------------------------------------------------------ |
| TMDXDOCK28M36     | The MAC address in the TMDXDOCK28M36 needs to be       |
|                   | updated from {0xff, 0xff, 0xff, 0xff, 0xff, 0xff} to a |
|                   | valid and unique address.                              |
| ----------------- | ------------------------------------------------------ |
| TMDXDOCKH52C1     | The MAC address in the TMDXDOCKH52C1 needs to be       |
|                   | updated from {0xff, 0xff, 0xff, 0xff, 0xff, 0xff} to a |
|                   | valid and unique address. Also, update jumpers on      |
|                   | Connectivity Back 01-15: B-C position (Ethernet)       |
| ----------------- | ------------------------------------------------------ |

Example Usage
-------------
The device must be connected to a network with a DHCP server to run this example
successfully.

The example turns ON Board_LED0 and starts the network stack. When the stack
receives an IPv6 address from the DHCP server, the address is written to the
console.

Run the udpSendReceive Linux or Windows executable that is shipped with TI-RTOS.
The executable is found in:

  <tirtos_install_dir>\packages\examples\tools\udpSendReceive

  Usage: ./udpSendReceive <IPv6-addr> <port> <id> -l[length] -s[sleep in uS]

  <IPv6-addr> is the IPv6 address. For Linux, append the ethernet port ("%eth0")
  <port>    is the UDP port being listened to (1000)
  <id>      is a unique id for the executable. Printed out when 1000 packets are
            transmitted. It allows the user to run multiple instances
            of udpSendReceive.

  optional:
    -l[length]      size of the packet in bytes. Default is 1024 bytes.
    -s[sleep in uS] usleep time to between sends. Default is 1000 uSecs.

  Windows Example:
        udpSendReceive fe80::aa63:f2ff:fe00:491 1000 1 -s100
  Linux Example:
        udpSendReceive fe80::aa63:f2ff:fe00:491%eth0 1000 1 -s100

Messages such as the following will begin to appear on the terminal window when
a UDP packet has been echoed back:

        Starting test with a 1000 uSec delay between transmits
        [id 1] count = 1000, time = 12
        [id 1] count = 2000, time = 24
        [id 1] count = 3000, time = 36

Application Design Details
--------------------------
This application uses one task:
  'udpHandler' performs the following actions:
      Create a socket and bind it to a port (1000 for this example).

      Wait for client before timing-out.

      Receive data from socket if a client is connected.

      Echo the UDP packet back to the client.

      When client closes the socket, close server socket, and exit the task.

For GNU and IAR users, please read the following website for details about
semi-hosting:
    http://processors.wiki.ti.com/index.php/TI-RTOS_Examples_SemiHosting
