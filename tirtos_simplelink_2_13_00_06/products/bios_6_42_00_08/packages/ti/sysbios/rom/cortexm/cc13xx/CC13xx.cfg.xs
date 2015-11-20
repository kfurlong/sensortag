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

var CC13xx = xdc.module('ti.sysbios.rom.cortexm.cc13xx.CC13xx');

var Build = xdc.useModule('ti.sysbios.Build');
Build.buildROM = false;
Build.buildROMApp = true;

var BIOS = xdc.useModule('ti.sysbios.BIOS');
if (BIOS.$written("swiEnabled") && BIOS.swiEnabled == false) {
    CC13xx.$logWarning("BIOS.swiEnabled must be set to true for ROM applications.", BIOS, "swiEnabled");
}
BIOS.swiEnabled = true;

if (BIOS.$written("logsEnabled") && BIOS.logsEnabled == true) {
    CC13xx.$logWarning("BIOS.logsEnabled must be set to false for ROM applications.", BIOS, "logsEnabled");
}
BIOS.logsEnabled = false;

if (BIOS.$written("assertsEnabled") && BIOS.assertsEnabled == true) {
    CC13xx.$logWarning("BIOS.assertsEnabled must be set to false for ROM applications.", BIOS, "assertsEnabled");
}
BIOS.assertsEnabled = false;

if (BIOS.$written("includeXdcRuntime") && BIOS.includeXdcRuntime == false) {
    CC13xx.$logWarning("BIOS.includeXdcRuntimeEnabled must be set to true for ROM applications.", BIOS, "includeXdcRuntime");
}
BIOS.includeXdcRuntime = true;

/* allow Mod_construct() Mod_destruct() */
if (BIOS.$written("runtimeCreatesEnabled") && BIOS.runtimeCreatesEnabled == false) {
    CC13xx.$logWarning("BIOS.runtimeCreatesEnabled must be set to true for ROM applications.", BIOS, "runtimeCreatesEnabled");
}
BIOS.runtimeCreatesEnabled = true;

/* List of modules needed to build ROM executable */
var Defaults = xdc.useModule('xdc.runtime.Defaults');
var Types = xdc.useModule('xdc.runtime.Types');
var Diags = xdc.useModule('xdc.runtime.Diags');
var LocalError = xdc.useModule('xdc.runtime.Error');
var Main = xdc.useModule('xdc.runtime.Main');
var SysCallback = xdc.useModule('xdc.runtime.SysCallback');
var System = xdc.useModule('xdc.runtime.System');
var Text = xdc.useModule('xdc.runtime.Text');

/* use the minimal user-supplied callback provider */
if (System.$written("SupportProxy") == false) {
    System.SupportProxy = SysCallback;
}

/* disable sorting by task priority */
var Semaphore = xdc.useModule('ti.sysbios.knl.Semaphore');
if (Semaphore.$written("supportsPriority") && Semaphore.supportsPriority == true) {
    CC13xx.$logWarning("Semaphore.supportsPriority must be set to false for ROM applications.", Semaphore, "supportsPriority");
}
Semaphore.supportsPriority = false;

/* don't check stacks for overflow - saves cycles (and power) and Flash */
var Task = xdc.useModule('ti.sysbios.knl.Task');
if (Task.$written("checkStackFlag") && Task.checkStackFlag == true) {
    CC13xx.$logWarning("Task.checkStackFlag must be set to false for ROM applications.", Task, "checkStackFlag");
}
Task.checkStackFlag = false; /* avoids pulling in Task_checkStacks() */
                             /* also removes all Task HOOK code from library */


/* use the cc13xx Timer and TimestampProvider modules */
var rtcTimer = xdc.useModule('ti.sysbios.family.arm.cc26xx.Timer');
var Clock = xdc.useModule('ti.sysbios.knl.Clock');
Clock.TimerProxy = rtcTimer;

var rtcTimestamp = xdc.useModule('ti.sysbios.family.arm.cc26xx.TimestampProvider');
var Timestamp = xdc.useModule('xdc.runtime.Timestamp');
Timestamp.SupportProxy = rtcTimestamp;

/* don't check for interrupt stack overflow during Idle loop */
var halHwi = xdc.useModule('ti.sysbios.hal.Hwi');
if (halHwi.$written("checkStackFlag") && halHwi.checkStackFlag == true) {
    CC13xx.$logWarning("Hwi.checkStackFlag must be set to false for ROM applications.", halHwi, "checkStackFlag");
}
halHwi.checkStackFlag = false; /* avoids pulling in hal Hwi_checkStack() */

xdc.loadCapsule("ti/sysbios/rom/cortexm/cc13xx/CC13xx_externs.xs");

if (Program.build.target.$name.match(/gnu/)) {
    var Reset = xdc.useModule('xdc.runtime.Reset');
    Reset.fxns[Reset.fxns.length++] =
        "&ti_sysbios_rom_cortexm_cc13xx_CC13xx_dataInit"

    var ReentSupport = xdc.useModule('ti.sysbios.rts.gnu.ReentSupport');
    ReentSupport.enableReentSupport = false;

    var Platform = xdc.module('ti.platforms.simplelink.Platform');
    Platform.useGnuRomLinkCmd = true;
}

/* force ROM and ROM apps to be built against the pg2 driverlibs */
var Boot = xdc.module('ti.sysbios.family.arm.cc26xx.Boot');
Boot.driverlibVersion = 2;
