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
 *  ======== pthread_barrier.c ========
 */

#include <xdc/std.h>
#include <xdc/runtime/Assert.h>
#include <xdc/runtime/Diags.h>
#include <xdc/runtime/Error.h>
#include <xdc/runtime/Memory.h>

#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/hal/Hwi.h>
#include <ti/sysbios/knl/Clock.h>
#include <ti/sysbios/knl/Semaphore.h>
#include <ti/sysbios/knl/Task.h>

#include <ti/sysbios/posix/pthread.h>
#include <ti/sysbios/posix/_pthread_error.h>

#define _PTHREAD_DEBUG 1

/*
 *  ======== pthread_barrier_Obj ========
 */
typedef struct pthread_barrier_Obj {
    Semaphore_Struct  sem;
    int               count;
    int               pendCount;
} pthread_barrier_Obj;

/*
 *************************************************************************
 *                      pthread_barrierattr
 *************************************************************************
 */
/*
 *  ======== pthread_barrierattr_destroy ========
 */
int pthread_barrierattr_destroy(pthread_barrierattr_t *attr)
{
    return (0);
}

/*
 *  ======== pthread_barrierattr_getpshared ========
 */
int pthread_barrierattr_getpshared(const pthread_barrierattr_t *attr, int *pshared)
{
    *pshared = attr->pshared;
    return (0);
}

/*
 *  ======== pthread_barrierattr_init ========
 */
int pthread_barrierattr_init(pthread_barrierattr_t * attr)
{
    attr->pshared = PTHREAD_PROCESS_PRIVATE;
    return (0);
}

/*
 *  ======== pthread_barrierattr_setpshared ========
 */
int pthread_barrierattr_setpshared(pthread_barrierattr_t *attr, int pshared)
{
    if ((pshared != PTHREAD_PROCESS_PRIVATE) &&
            (pshared != PTHREAD_PROCESS_SHARED)) {
        return (EINVAL);
    }

    attr->pshared = pshared;
    return (0);
}

/*
 *************************************************************************
 *                      pthread_barrier
 *************************************************************************
 */

/*
 *  ======== pthread_barrier_destroy ========
 */
int pthread_barrier_destroy(pthread_barrier_t *barrier)
{
    pthread_barrier_Obj *barrierObj = (pthread_barrier_Obj *)*barrier;

    Semaphore_destruct(&(barrierObj->sem));

    Memory_free(Task_Object_heap(), barrierObj, sizeof(pthread_barrier_Obj));
    *barrier = NULL;

    return (0);
}

/*
 *  ======== pthread_barrier_init ========
 */
int pthread_barrier_init(pthread_barrier_t *barrier,
        const pthread_barrierattr_t *attr, unsigned count)
{
    pthread_barrier_Obj *barrierObj;
    Semaphore_Params    semParams;
    Error_Block         eb;

    Error_init(&eb);

    // TODO: Is Task_Object_heap() ok to use?
    barrierObj = (pthread_barrier_Obj *)Memory_alloc(Task_Object_heap(),
            sizeof(pthread_barrier_Obj), 0, &eb);

    if (barrierObj == NULL) {
        return (ENOMEM);
    }

    barrierObj->count = count;
    barrierObj->pendCount = 0;

    Semaphore_Params_init(&semParams);
    semParams.mode = Semaphore_Mode_COUNTING;

    Semaphore_construct(&(barrierObj->sem), 0, &semParams);

    *barrier = (void *)barrierObj;

    return (0);
}

/*
 *  ======== pthread_barrier_wait ========
 */
int pthread_barrier_wait(pthread_barrier_t *barrier)
{
    pthread_barrier_Obj *barrierObj = (pthread_barrier_Obj *)*barrier;
    UInt                 key;
    int                  i;

    key = Task_disable();

    if (++barrierObj->pendCount < barrierObj->count) {
        Task_restore(key);
        Semaphore_pend(Semaphore_handle(&(barrierObj->sem)),
                BIOS_WAIT_FOREVER);
    }
    else {
        for (i = 0; i < barrierObj->count - 1; i++) {
            Semaphore_post(Semaphore_handle(&(barrierObj->sem)));
        }

        /* Re-initialize the barrier */
        barrierObj->pendCount = 0;

        Task_restore(key);

        /*
         *  pthread_barrier_wait() returs PTHREAD_BARRIER_SERIAL_THREAD
         *  for one arbitrarily chosen thread, so we'll choose the
         *  last one to wait.  The return value for all other threads
         *  is 0.
         */
        return (PTHREAD_BARRIER_SERIAL_THREAD);
    }

    return (0);
}
