/*
 * Copyright (c) 2014, Texas Instruments Incorporated
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
 *  ======== fatsdraw.c ========
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

/* XDCtools Header files */
#include <xdc/std.h>
#include <xdc/cfg/global.h>
#include <xdc/runtime/System.h>

/* BIOS Header files */
#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/fatfs/ff.h>
#include <ti/sysbios/knl/Clock.h>

/* TI-RTOS Header files */
#include <ti/drivers/GPIO.h>
#include <ti/drivers/SDSPI.h>

/* Example/Board Header files */
#include "Board.h"

/* Buffer size used for the file copy process */
#ifndef CPY_BUFF_SIZE
#define CPY_BUFF_SIZE       2048
#endif

/* String conversion macro */
#define STR_(n)             #n
#define STR(n)              STR_(n)

/* Drive number used for FatFs */
#define DRIVE_NUM           0

const char  inputfile[] = STR(DRIVE_NUM)":input.txt";
const char outputfile[] = STR(DRIVE_NUM)":output.txt";

const char textarray[] = \
"***********************************************************************\n"
"0         1         2         3         4         5         6         7\n"
"01234567890123456789012345678901234567890123456789012345678901234567890\n"
"This is some text to be inserted into the inputfile if there isn't     \n"
"already an existing file located on the SDCard.                        \n"
"If an inputfile already exists, or if the file was already once        \n"
"generated, then the inputfile will NOT be modified.                    \n"
"***********************************************************************\n";

unsigned char cpy_buff[CPY_BUFF_SIZE + 1];
FIL src;
FIL dst;

/*
 *  ======== printDrive ========
 *  Function to print drive information such as the total disk space
 *  This function was created by referencing FatFs's API documentation
 *  http://elm-chan.org/fsw/ff/en/getfree.html
 *
 *  This function call may take a while to process, depending on the size of
 *  SD Card used.
 */
void printDrive(const char *driveNumber, FATFS **fatfs)
{
    FRESULT        fresult;
    DWORD          freeClusterCount;
    DWORD          totalSectorCount;
    DWORD          freeSectorCount;

    System_printf("Reading disk information...");
    System_flush();

    fresult = f_getfree(driveNumber, &freeClusterCount, fatfs);
    if (fresult) {
        System_abort("Error getting the free cluster count from the FatFs object");
    }
    else {
        System_printf("done\n");

        /* Get total sectors and free sectors */
        totalSectorCount = ((*fatfs)->n_fatent - 2) * (*fatfs)->csize;
        freeSectorCount  = freeClusterCount * (*fatfs)->csize;

        /* Print the free space (assuming 512 bytes/sector) */
        System_printf("Total Disk size: %10lu KiB\n"
                      "Free Disk space: %10lu KiB\n",
                      totalSectorCount / 2,
                      freeSectorCount  / 2);
    }
}

/*
 *  ======== taskFxn ========
 *  Task to perform a file copy
 *
 *  Task tries to open an existing file inputfile[]. If the file doesn't
 *  exist, create one and write some known content into it.
 *  The contents of the inputfile[] are then copied to an output file
 *  outputfile[]. Once completed, the contents of the output file are
 *  printed onto the system console (stdout).
 *
 *  Task for this function is created statically. See the project's .cfg file.
 */
Void taskFxn(UArg arg0, UArg arg1)
{
    FRESULT fresult;
    SDSPI_Handle sdspiHandle;
    SDSPI_Params sdspiParams;

    /* Variables to keep track of the file copy progress */
    unsigned int bytesRead = 0;
    unsigned int bytesWritten = 0;
    unsigned int filesize;
    unsigned int totalBytesCopied = 0;

    /* Mount and register the SD Card */
    SDSPI_Params_init(&sdspiParams);
    sdspiHandle = SDSPI_open(Board_SDSPI0, DRIVE_NUM, &sdspiParams);
    if (sdspiHandle == NULL) {
        System_abort("Error starting the SD card\n");
    }
    else {
        System_printf("Drive %u is mounted\n", DRIVE_NUM);
    }

    printDrive(STR(DRIVE_NUM), &(dst.fs));

    /* Try to open the source file */
    fresult = f_open(&src, inputfile, FA_READ);
    if (fresult != FR_OK) {
        System_printf("Creating a new file \"%s\"...", inputfile);

        /* Open file for both reading and writing */
        fresult = f_open(&src, inputfile, FA_CREATE_NEW|FA_READ|FA_WRITE);
        if (fresult != FR_OK) {
            System_printf("Error: \"%s\" could not be created.\n"
                          "Please check the Getting Started Guide "
                          "if additional jumpers are necessary.\n",
                          inputfile);
            System_abort("Aborting...\n");
        }

        f_write(&src, textarray, strlen(textarray), &bytesWritten);
        f_sync(&src);

        /* Reset the internal file pointer */
        f_lseek(&src, 0);

        System_printf("done\n");
    }
    else {
        System_printf("Using existing copy of \"%s\"\n", inputfile);
    }

    /* Create a new file object for the file copy */
    fresult = f_open(&dst, outputfile, FA_CREATE_ALWAYS|FA_WRITE);
    if (fresult != FR_OK) {
        System_printf("Error opening \"%s\"\n", outputfile);
        System_abort("Aborting...\n");
    }
    else {
        System_printf("Starting file copy\n");
    }

    /*  Copy the contents from the src to the dst */
    while (true) {
        /*  Read from source file */
        fresult = f_read(&src, cpy_buff, CPY_BUFF_SIZE, &bytesRead);
        if (fresult || bytesRead == 0) {
            break; /* Error or EOF */
        }

        /*  Write to dst file */
        fresult = f_write(&dst, cpy_buff, bytesRead, &bytesWritten);
        if (fresult || bytesWritten < bytesRead) {
            System_printf("Disk Full\n");
            break; /* Error or Disk Full */
        }

        /*  Update the total number of bytes copied */
        totalBytesCopied += bytesWritten;
    }

    f_sync(&dst);

    /* Get the filesize of the source file */
    filesize = f_size(&src);

    /* Close both inputfile[] and outputfile[] */
    f_close(&src);
    f_close(&dst);

    System_printf("File \"%s\" (%u B) copied to \"%s\" (Wrote %u B)\n",
                  inputfile, filesize, outputfile, totalBytesCopied);

    /* Now output the outputfile[] contents onto the console */
    fresult = f_open(&dst, outputfile, FA_READ);
    if (fresult != FR_OK) {
        System_printf("Error opening \"%s\"\n", outputfile);
        System_abort("Aborting...\n");
    }

    /* Print file contents */
    while (true) {
        /* Read from output file */
        fresult = f_read(&dst, cpy_buff, CPY_BUFF_SIZE, &bytesRead);
        if (fresult || bytesRead == 0) {
            break; /* Error or EOF */
        }
        cpy_buff[bytesRead] = '\0';
        /* Write output */
        System_printf("%s", cpy_buff);
        System_flush();
    }

    /* Close the file */
    f_close(&dst);

    printDrive(STR(DRIVE_NUM), &(dst.fs));

    /* Stopping the SDCard */
    SDSPI_close(sdspiHandle);
    System_printf("Drive %u unmounted\n", DRIVE_NUM);

    BIOS_exit(0);
}

/*
 *  ======== main ========
 */
int main(void)
{
    /* Call board init functions */
    Board_initGeneral();
    Board_initGPIO();
    Board_initSDSPI();

    /* Turn on user LED */
    GPIO_write(Board_LED0, Board_LED_ON);

    System_printf("Starting the FatSD Raw example\n");

    /* Start BIOS */
    BIOS_start();

    return (0);
}
