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

#include <ti/drivers/WiFi.h>

#include <stdint.h>
#include <stdlib.h>

/* Externs */
extern const WiFi_Config WiFi_config[];

/* Number of WiFi modules. -1 if init has not been called. */
static int WiFi_count = -1;

/* Default WiFi parameters structure */
const WiFi_Params WiFi_defaultParams = {
    1000000, /* bitRate */
    NULL     /* custom */
};

/*
 *  ======== WiFi_close ========
 */
void WiFi_close(WiFi_Handle handle)
{
    handle->fxnTablePtr->closeFxn(handle);
}

/*
 *  ======== WiFi_control ========
 */
int WiFi_control(WiFi_Handle handle, unsigned int cmd, void *arg)
{
    return (handle->fxnTablePtr->controlFxn(handle, cmd, arg));
}

/*
 *  ======== WiFi_init ========
 */
void WiFi_init()
{
    /* Return if this function has already been called */
    if (WiFi_count == -1) {
        /* Call each driver's init function */
        for (WiFi_count = 0; WiFi_config[WiFi_count].fxnTablePtr != NULL;
             WiFi_count++) {
            WiFi_config[WiFi_count].fxnTablePtr->initFxn(
                (WiFi_Handle)&(WiFi_config[WiFi_count]));
        }
    }
}

/*
 *  ======== WiFi_open ========
 */
WiFi_Handle WiFi_open(unsigned int wifiIndex, unsigned int spiIndex,
                      WiFi_evntCallback evntCallback, WiFi_Params *params)
{
    WiFi_Handle handle;

    /* Get the handle for this driver instance */
    handle = (WiFi_Handle)&(WiFi_config[wifiIndex]);

    return (handle->fxnTablePtr->openFxn(handle, spiIndex, evntCallback,
                                         params));
}

/*
 *  ======== WiFi_Params_init ========
 */
void WiFi_Params_init(WiFi_Params *params)
{
    *params = WiFi_defaultParams;
}
