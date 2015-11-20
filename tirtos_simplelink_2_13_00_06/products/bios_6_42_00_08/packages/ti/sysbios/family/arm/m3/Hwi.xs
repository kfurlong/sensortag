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
 *  ======== Hwi.xs ========
 */

var Hwi = null;
var Memory = null;
var Startup = null;
var BIOS = null;
var Build = null;
var Core = null;

/*
 * ======== getAsmFiles ========
 * return the array of assembly language files associated
 * with targetName (ie Program.build.target.$name)
 */
function getAsmFiles(targetName)
{
    switch(targetName) {
        case "ti.targets.arm.elf.M3":
        case "ti.targets.arm.elf.M4":
        case "ti.targets.arm.elf.M4F":
            return (["Hwi_asm.sv7M", "Hwi_asm_switch.sv7M"]);
            break;

        case "gnu.targets.arm.M3":
        case "gnu.targets.arm.M4":
        case "gnu.targets.arm.M4F":
            return (["Hwi_asm_gnu.sv7M", "Hwi_asm_switch_gnu.sv7M"]);
            break;

        case "iar.targets.arm.M3":
        case "iar.targets.arm.M4":
        case "iar.targets.arm.M4F":
            return (["Hwi_asm_iar.sv7M", "Hwi_asm_switch_iar.sv7M"]);
            break;

	default:
	    return (null);
	    break;
    }
}

/*
 * ======== getCFiles ========
 * return the array of C language files associated
 * with targetName (ie Program.build.target.$name)
 */
function getCFiles(targetName)
{
    if (BIOS.smpEnabled) {
        return (["Hwi_smp.c"]);
    }
    else {
        return (["Hwi.c"]);
    }
}

if (xdc.om.$name == "cfg") {
    var deviceTable = {
        "CortexM3": {
            numInterrupts : 16 + 64,
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0,
        },
        "OMAP4430": {
            numInterrupts : 16 + 64,
            numPriorities : 16,
            resetVectorAddress : 0,
            vectorTableAddress : 0,
        },
        "LM3.*": {
            numInterrupts : 16 + 64,
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0x20000000,
        },
        "LM4.*": {
            numInterrupts : 16 + 200,   /* up to 216 for Flurry devices */
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0x20000000,
        },
        "TM4.*": {
            numInterrupts : 16 + 200,   /* up to 216 for Flurry devices */
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0x20000000,
        },
        "MSP432.*": {
            numInterrupts : 16 + 64,
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0x20000000,
        },
        "SC.*": {
            numInterrupts : 16 + 200,   /* up to 216 for Blizzard devices */
            numPriorities : 8,
            resetVectorAddress : 0,
            vectorTableAddress : 0x20000000,
        },
        "F28M35.*": {
            numInterrupts : 16 + 92,            /* suppports 108 interrupts */
            numPriorities : 8,
            resetVectorAddress : 0x00200040,    /* placed low in flash */
            vectorTableAddress : 0x20000000,
        },
        "F28M36.*": {
            numInterrupts : 16 + 134,           /* supports 150 interrupts */
            numPriorities : 8,
            resetVectorAddress : 0x00200040,    /* placed low in flash */
            vectorTableAddress : 0x20000000,
        },
        "CC2538.*": {
            numInterrupts : 16 + 147,           /* supports 163 interrupts */
            numPriorities : 8,
            resetVectorAddress : 0x00200000,    /* placed low in flash */
            vectorTableAddress : 0x20000000,
        },
        "CC26.*": {
            numInterrupts : 16 + 39,            /* supports 55 interrupts */
            numPriorities : 8,
            resetVectorAddress : 0x0,           /* placed low in flash */
            vectorTableAddress : 0x20000000,
        },
        "CC3200": {
            numInterrupts : 16 + 179,
            numPriorities : 8,
            resetVectorAddress : 0x20004000,
            vectorTableAddress : 0x20004000,
        }
    }

    deviceTable["TMS470R10"]    = deviceTable["CortexM3"];

    deviceTable["TMS320CDM740"]  = deviceTable["OMAP4430"];
    deviceTable["Ducati"]        = deviceTable["OMAP4430"];
    deviceTable["TMS320TI811X"]  = deviceTable["OMAP4430"];
    deviceTable["TMS320TI813X"]  = deviceTable["OMAP4430"];
    deviceTable["TMS320TI814X"]  = deviceTable["OMAP4430"];
    deviceTable["TMS320TI816X"]  = deviceTable["OMAP4430"];
    deviceTable["TMS320DM385"]   = deviceTable["OMAP4430"];
    deviceTable["TMS320DM8168"]  = deviceTable["OMAP4430"];
    deviceTable["TMS320C6A8168"] = deviceTable["OMAP4430"];
    deviceTable["TMS320C6A8149"] = deviceTable["OMAP4430"];
    deviceTable["TMS320DM8148"]  = deviceTable["OMAP4430"];
    deviceTable["OMAP5430"]      = deviceTable["OMAP4430"];
    deviceTable["Vayu"]          = deviceTable["OMAP4430"];
    deviceTable["DRA7XX"]        = deviceTable["OMAP4430"];
    deviceTable["TDA3XX"]        = deviceTable["OMAP4430"];
    deviceTable["CC13.*"]        = deviceTable["CC26.*"];
}

/*
 *  ======== deviceSupportCheck ========
 *  Check validity of device
 */
function deviceSupportCheck()
{
    var deviceName;

    for (deviceName in deviceTable) {
        if (deviceName == Program.cpu.deviceName) {
            return deviceName;
        }
    }

    /* now look for wild card match */
    for (deviceName in deviceTable) {
        if (Program.cpu.deviceName.match(deviceName)) {
            return deviceName;
        }
    }

    Hwi.$logError("Unsupported device!", Program.cpu.deviceName);
}

/*
 *  ======== module$meta$init ========
 */
function module$meta$init()
{
    /* Only process during "cfg" phase */
    if (xdc.om.$name != "cfg") {
        return;
    }

    /* provide getAsmFiles() for Build.getAsmFiles() */
    this.$private.getAsmFiles = getAsmFiles;

    /* provide getCFiles() for Build.getCFiles() */
    this.$private.getCFiles = getCFiles;

    Hwi = this;

    /* set fxntab default */
    Hwi.common$.fxntab = false;

    var GetSet = xdc.module("xdc.services.getset.GetSet");
    GetSet.onSet(this, "enableException", _enableExceptionSet);
    GetSet.onSet(this, "excHandlerFunc", _excHandlerFuncSet);

    var deviceName = deviceSupportCheck();

    if (Program.platformName.match(/ti\.platforms\.tiva/) ||
        Program.platformName.match(/ti\.platforms\.cc26xx/) ||
        Program.platformName.match(/ti\.platforms\.msp432/) ||
        Program.platformName.match(/ti\.platforms\.simplelink/)) {
        Hwi.isTiva = true;
    }
    else {
        Hwi.isTiva = false;
    }

    Hwi.NUM_INTERRUPTS = deviceTable[deviceName].numInterrupts;
    Hwi.NUM_PRIORITIES = deviceTable[deviceName].numPriorities;
    Hwi.dispatchTableSize = deviceTable[deviceName].numInterrupts;
    Hwi.resetVectorAddress = deviceTable[deviceName].resetVectorAddress;
    Hwi.vectorTableAddress = deviceTable[deviceName].vectorTableAddress;

    Hwi.intAffinity.length = 256;

    /* by default, exception context is saved on local ISR stack */
    Hwi.excContextBuffer = 0;
    Hwi.excContextBuffers.length = 2;
    Hwi.excContextBuffers[0] = 0;
    Hwi.excContextBuffers[1] = 0;

    /* by default, the exception thread stack is NOT copied */
    Hwi.excStackBuffer = null;
    Hwi.excStackBuffers.length = 2;
    Hwi.excStackBuffers[0] = null;
    Hwi.excStackBuffers[1] = null;

    Hwi.excHookFuncs.length = 2;
    Hwi.excHookFuncs[0] = null;
    Hwi.excHookFuncs[1] = null;

    /* kill xdc runtime's .bootVecs */
    Program.sectMap[".bootVecs"] = new Program.SectionSpec();
    Program.sectMap[".bootVecs"].type = "DSECT";

    if (!Program.build.target.$name.match(/gnu/)) {
        /* create our .vecs & .resetVecs SectionSpecs */
        Program.sectMap[".vecs"] = new Program.SectionSpec();
        Program.sectMap[".resetVecs"] = new Program.SectionSpec();
    }

    /*
     * Initialize meta-only Hwi object array
     */

    /*
     * Set the meta array size to support the max number of interrupts.
     * The actual number is defined by NUM_INTERRUPTS
     */
    Hwi.interrupt.length = 256;

    for (var intNum = 0; intNum < Hwi.interrupt.length; intNum++) {
        Hwi.interrupt[intNum].used = false;
        Hwi.interrupt[intNum].useDispatcher = false;
        Hwi.interrupt[intNum].fxn = null;
        Hwi.interrupt[intNum].name = "";

        /* all ints are mapped to core 0 by default */
        Hwi.intAffinity[intNum] = 0;
    }

    if (Program.build.target.$name.match(/iar\./)) {
        /* Don't get the vector table from rts library */
        var VectorTable = xdc.module('iar.targets.arm.rts.VectorTable');
        VectorTable.getVectorTableLib = false;

        Hwi.resetFunc = '&__iar_program_start';
    }
    else {
        Hwi.resetFunc = '&_c_int00';
    }

    switch (Hwi.NUM_PRIORITIES) {
        case 2:
            Hwi.disablePriority = 0x80;
            break;
        case 4:
            Hwi.disablePriority = 0x40;
            break;
        case 8:
            Hwi.disablePriority = 0x20;
            break;
        case 16:
            Hwi.disablePriority = 0x10;
            break;
        case 32:
            Hwi.disablePriority = 0x08;
            break;
        case 64:
            Hwi.disablePriority = 0x04;
            break;
        case 128:
            Hwi.disablePriority = 0x02;
            break;
        case 256:
        default:
            Hwi.disablePriority = 0x01;
            break;
    }
}

/*
 *  ======== module$use ========
 */
function module$use()
{
    Startup = xdc.useModule('xdc.runtime.Startup');

    xdc.useModule('xdc.runtime.Log');

    BIOS = xdc.useModule("ti.sysbios.BIOS");
    Build = xdc.module("ti.sysbios.Build");
    
    if (BIOS.smpEnabled == true) {
        Core = xdc.module("ti.sysbios.hal.Core");
    }

    /* only useModule(Memory) if needed */
    var Defaults = xdc.useModule('xdc.runtime.Defaults');
    if (Defaults.common$.memoryPolicy ==
        xdc.module("xdc.runtime.Types").STATIC_POLICY) {
        Memory = xdc.module('xdc.runtime.Memory');
    }
    else {
        Memory = xdc.useModule('xdc.runtime.Memory');
    }

    if (Hwi.dispatcherSwiSupport == undefined) {
        Hwi.dispatcherSwiSupport = BIOS.swiEnabled;
    }
    if (Hwi.dispatcherTaskSupport == undefined) {
        Hwi.dispatcherTaskSupport = BIOS.taskEnabled;
    }
    if (Hwi.dispatcherSwiSupport) {
        if (BIOS.swiEnabled) {
            xdc.useModule("ti.sysbios.knl.Swi");
            Hwi.swiDisable = '&ti_sysbios_knl_Swi_disable__E';
            Hwi.swiRestoreHwi = '&ti_sysbios_knl_Swi_restoreHwi__E';
        }
        else {
            Hwi.$logError("Dispatcher Swi support can't be enabled if ti.sysbios.BIOS.swiEnabled is false.", Hwi, "dispatcherSwiSupport");
        }
    }
    else {
        Hwi.swiDisable = null;
        Hwi.swiRestoreHwi = null;
    }

    if (Hwi.dispatcherTaskSupport) {
        if (BIOS.taskEnabled) {
            xdc.useModule("ti.sysbios.knl.Task");
            Hwi.taskDisable = '&ti_sysbios_knl_Task_disable__E';
            Hwi.taskRestoreHwi = '&ti_sysbios_knl_Task_restoreHwi__E';
        }
        else {
            Hwi.$logError ("Dispatcher Task support can't be enabled if ti.sysbios.BIOS.taskEnabled is false.", Hwi, "dispatcherTaskSupport");
        }
    }
    else {
        Hwi.taskDisable = null;
        Hwi.taskRestoreHwi = null;
    }

    /* Plug all non user-plugged exception handlers */
    if (Hwi.nmiFunc === undefined) {
        Hwi.nmiFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.hardFaultFunc === undefined) {
        Hwi.hardFaultFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.memFaultFunc === undefined) {
        Hwi.memFaultFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.busFaultFunc === undefined) {
        Hwi.busFaultFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.usageFaultFunc === undefined) {
        Hwi.usageFaultFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.svCallFunc === undefined) {
        Hwi.svCallFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.debugMonFunc === undefined) {
        Hwi.debugMonFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.reservedFunc === undefined) {
        Hwi.reservedFunc = Hwi.excHandlerAsm;
    }
    if (Hwi.nullIsrFunc === undefined) {
        Hwi.nullIsrFunc = Hwi.excHandlerAsm;
    }


    if (Hwi.enableWA1_1 == true) {
        Hwi.$logError ("The Hwi.enableWA1_1 flag is not supported in this version of BIOS", Hwi, "enableWA1_1");
    }

    /*
     * After config file is parsed, use the final value
     * of Hwi.NUM_INTERRUPTS to correct the meta interrupt
     * table size which is used to generate the vector
     * table in Hwi.xdt.
     */
    Hwi.interrupt.length = Hwi.NUM_INTERRUPTS;

    /*
     * plug full exception decode func if enabled and excHandlerFunc
     * hasn't been set by the user
     */
    if (Hwi.$written("excHandlerFunc") == false) {
	if (Hwi.enableException) {
	    Hwi.excHandlerFunc = Hwi.excHandlerMax;
	}
	else {
	    Hwi.excHandlerFunc = Hwi.excHandlerMin;
	}
    }

    /*
     *  Register Hwi_initIsrStackSize as a first function. It will be called
     *  after cinit and initialize the ISR stack size before the stack size
     *  is used by Hwi module startup code.
     */
    if (Program.build.target.$name.match(/iar/)) {
        var len = Startup.firstFxns.length
        Startup.firstFxns.length++;
        Startup.firstFxns[len] =
            '&ti_sysbios_family_arm_m3_Hwi_initIsrStackSize';
    }
}

/*
 *  ======== module$static$init ========
 */
function module$static$init(mod, params)
{

    if (BIOS.smpEnabled == true) {
        var numCores = Core.numCores;
        mod.intAffinity.length = Hwi.NUM_INTERRUPTS;
        mod.intAffinityMasks.length = Core.numCores;

        for (var i = 0; i < Core.numCores; i++) {
            mod.intAffinityMasks[i].length = (Hwi.interrupt.length + 15) / 32;
        }

        for (var i = 0; i < mod.intAffinityMasks.length; i++) {
            for (var j = 0; j < mod.intAffinityMasks[i].length; j++) {
                mod.intAffinityMasks[i][j] = 0;
            }
        }

        for (var i = 0; i < mod.intAffinity.length; i++) {
            if (Hwi.intAffinity[i] < Core.numCores) {
                mod.intAffinity[i] = Hwi.intAffinity[i];
                if (i >= 16) {
                    var index = (i-16) >> 5;
                    var mask = 1 << ((i-16) & 0x1f);
                    mod.intAffinityMasks[Hwi.intAffinity[i]][index] |= mask;
                }
            }
            else {
                Hwi.$logError("Invalid core Id (" + Hwi.intAffinity[i] +
                ") for Hwi " + i + ". Core ids must be less than " +
                Core.numCores + ".", this, "intAffinity");
            }
        }
    }
    else {
        var numCores = 1;
        mod.intAffinity.length = 0;
        mod.intAffinityMasks.length = 0;
    }

    mod.swiTaskKeys = 0x00000101;

    mod.vnvicFlushRequired = false;

    mod.taskSP = null;

    mod.excActive.length = numCores;
    mod.excContext.length = numCores;
    mod.excStack.length = numCores;

    if (Hwi.excContextBuffer != 0) {
        Hwi.excContextBuffers[0] = Hwi.excContextBuffer;
    }

    if (Hwi.excStackBuffer != null) {
        Hwi.excStackBuffers[0] = Hwi.excStackBuffer;
    }

    if (Hwi.excHookFunc != null) {
        Hwi.excHookFuncs[0] = Hwi.excHookFunc;
    }

    for (var i = 0; i < numCores; i++) {

        mod.excActive[i] = false;

        if (Hwi.excContextBuffers[i] != 0) {
            mod.excContext[i] = $addr(Hwi.excContextBuffers[i]);
        }
        else {
            mod.excContext[i] = null;
        }
        if (Hwi.excStackBuffers[i] != null) {
            mod.excStack[i] = Hwi.excStackBuffers[i];
        }
        else {
            mod.excStack[i] = null;
        }
    }

    mod.isrStack = null;
    mod.isrStackBase = $externPtr('__TI_STACK_BASE');
    /* Overriden by Hwi_initIsrStackSize() if IAR */
    mod.isrStackSize = Program.stack;

    mod.dispatchTable = $externPtr('ti_sysbios_family_arm_m3_Hwi_dispatchTable[0]');
    
    Hwi.ccr = (params.nvicCCR.STKALIGN << 9) |
              (params.nvicCCR.BFHFNMIGN << 8) |
              (params.nvicCCR.DIV_0_TRP << 4) |
              (params.nvicCCR.UNALIGN_TRP << 3) |
              (params.nvicCCR.USERSETMPEND << 1) |
              (params.nvicCCR.NONEBASETHRDENA << 0);

    /* Validate Hwi.priGroup */
    if (Hwi.priGroup > 7) {
        Hwi.$logError("Hwi.priGroup = " + Hwi.priGroup + " but must be between 0 - 7", this, "priGroup");
    }

    /*
     * Non GNU targets have to deal with legacy config files
     */
    if (!Program.build.target.$name.match(/gnu/)) {

        /*
         * Some legacy config files explicitly place the vector table sections
         * rather than setting Hwi.vectorTableAddress and Hwi.resetVectorAddress.
         * The ugly logic below attempts to achieve the desired config goal and
         * end up with a coherent configuration.
         */

        if (Program.sectMap[".resetVecs"].loadAddress === undefined) {
            Program.sectMap[".resetVecs"].loadAddress = Hwi.resetVectorAddress;
        }
        else {
            if (Hwi.resetVectorAddress !=
                        Program.sectMap[".resetVecs"].loadAddress) {
                /* force config to match section placement */
                Hwi.$unseal("resetVectorAddress");
                Hwi.resetVectorAddress = Program.sectMap[".resetVecs"].loadAddress;
            }
        }

        if (Program.sectMap[".vecs"].loadAddress === undefined) {
            Program.sectMap[".vecs"].loadAddress = Hwi.vectorTableAddress;
        }
        else {
            if (Hwi.vectorTableAddress
                        != Program.sectMap[".vecs"].loadAddress) {
                /* force config match section placement */
                Hwi.$unseal("vectorTableAddress");
                Hwi.vectorTableAddress = Program.sectMap[".vecs"].loadAddress;
            }
        }

        /* remove empty .vecs section if it isn't used */
        if (Hwi.resetVectorAddress == Hwi.vectorTableAddress) {
            Program.sectMap[".vecs"].type = "DSECT";
        }
    }

    /* Initialize the NVIC early */
    if ((Hwi.resetVectorAddress != 0) && (Build.buildROMApp == true)) {
        /* Fix for SDOCM00114681: broken Hwi_initNVIC() function. */
	var ROM = xdc.module('ti.sysbios.rom.ROM');
        switch (ROM.romName) {
            case ROM.CC1350:
            case ROM.CC2650:
                Startup.firstFxns.$add(Hwi.cc26xxRomInitNVIC);
                break;

	    default:
                Startup.firstFxns.$add(Hwi.initNVIC);
	}
    }
    else {
        Startup.firstFxns.$add(Hwi.initNVIC);
    }

    mod.vectorTableBase = Hwi.vectorTableAddress;

    if (Hwi.vectorTableAddress > 0x3fffc000) {
        Hwi.$logError("Vector Table must be placed at or below 0x3FFFFC00",
                    this);
    }
    
    if (Hwi.dispatchTableSize < Hwi.NUM_INTERRUPTS) {
        Hwi.numSparseInterrupts = Hwi.dispatchTableSize;
        if (Hwi.dispatchTableSize > Hwi.NUM_INTERRUPTS) {
            Hwi.$logError("(" + Hwi.dispatchTableSize + ") " +
            "must be less than or equal to Hwi.NUM_INTERRUPTS: (" +
            Hwi.NUM_INTERRUPTS + ")",
             this, "dispatchTableSize");
        }
        else if (Hwi.dispatchTableSize > Hwi.NUM_INTERRUPTS / 3) {
            Hwi.$logWarning("(" + Hwi.dispatchTableSize + ") " +
            "should only be set to a value less than 1/3 " +
            "Hwi.NUM_INTERRUPTS: (" + Hwi.NUM_INTERRUPTS + ")",
             this, "dispatchTableSize");
        }

	/* place msp432's sparse dispatchTable in SRAM_CODE */
	if (Program.platformName.match(/ti\.platforms\.msp432/)) {
	     Build.ccArgs.$add("-Dti_sysbios_family_arm_m3_Hwi_FIX_MSP432_DISPATCH_TABLE_ADDRESS");
	}
    }

    /* add -D to compile line to optimize exception code */
    Build.ccArgs.$add("-Dti_sysbios_family_arm_m3_Hwi_enableException__D=" + 
        (Hwi.enableException ? "TRUE" : "FALSE"));

    if (BIOS.buildingAppLib == true) {
        /* add -D to compile line to optimize exception code */
        Build.ccArgs.$add("-Dti_sysbios_family_arm_m3_Hwi_disablePriority__D=" + 
            Hwi.disablePriority + "U");

        if (Build.buildROM == false) {
	    /* add -D to compile line to optimize sparse interrupt handling code */
	    Build.ccArgs.$add("-Dti_sysbios_family_arm_m3_Hwi_numSparseInterrupts__D=" + 
                Hwi.numSparseInterrupts + "U");
	}
    }
}

/*
 *  ======== instance$static$init ========
 */
function instance$static$init(obj, intNum, fxn, params)
{

    var mod = this.$module.$object;

    if (intNum < 15) {
        Hwi.$logError("Only intNums > = 15 can be created.", this, intNum);
    }

    if (Hwi.interrupt[intNum].used == true) {
        Hwi.$logError("Hwi " + intNum + " already in use (by " +
                Hwi.interrupt[intNum].fxn + ").", this);
    }

    Hwi.interrupt[intNum].used = true;
    Hwi.interrupt[intNum].fxn = fxn;

    obj.arg = params.arg;
    obj.fxn = fxn;
    obj.intNum = intNum;

    if (params.priority != -1) {
        obj.priority = params.priority;
    }
    else {
        obj.priority = 255;
    }

    Hwi.interrupt[intNum].priority = obj.priority;

    /*
     * obj.irp field is overloaded during initialization
     * to reduce Hwi Object footprint
     *
     * for postInit(), encode irp with enableInt
     * and useDispatcher info.
     */

    obj.irp = 0;

    if (params.enableInt == true) {
        obj.irp |= 0x1;
    }

    if (params.useDispatcher == true) {
        obj.irp |= 0x2;
    }

    /* Zero latency interrupts don't use the dispatcher */
    if ((params.useDispatcher == false) ||
        (obj.priority < Hwi.disablePriority)) {
        Hwi.interrupt[intNum].useDispatcher = false;
    }
    else {
        Hwi.interrupt[intNum].useDispatcher = true;
        Hwi.interrupt[intNum].hwi = this;
    }

    if ((params.maskSetting != Hwi.MaskingOption_LOWER)
        && (params.maskSetting != Hwi.MaskingOption_SELF)) {
        Hwi.$logWarning("M3 BIOS only supports Hwi.MaskingOption_LOWER",
                        this);
    }

    obj.hookEnv.length = Hwi.hooks.length;
}

/*
 *  ======== inUseMeta ========
 */
function inUseMeta(intNum)
{
    return Hwi.interrupt[intNum].used;
}

/*
 *  ======== addHookSet ========
 */
function addHookSet(hookSet)
{
    /* use "===" so 'null' is not flagged */
    if (hookSet.registerFxn === undefined) {
        hookSet.registerFxn = null;
    }
    if (hookSet.createFxn === undefined) {
        hookSet.createFxn = null;
    }
    if (hookSet.beginFxn === undefined) {
        hookSet.beginFxn = null;
    }
    if (hookSet.endFxn === undefined) {
        hookSet.endFxn = null;
    }
    if (hookSet.deleteFxn === undefined) {
        hookSet.deleteFxn = null;
    }

    this.hooks.$add(hookSet);
}

/*
 *  ======== module$validate ========
 */
function module$validate()
{
    /* validate all "created" instances */
    for (var i = 0; i < Hwi.$instances.length; i++) {
        instance_validate(Hwi.$instances[i]);
    }

    /* validate all "constructed" instances */
    for (var i = 0; i < Hwi.$objects.length; i++) {
        instance_validate(Hwi.$objects[i]);
    }
}

/*
 *  ======== instance_validate ========
 *  common function to test instance configuration
 */
function instance_validate(instance)
{
    if (instance.$object.fxn == null) {
        Hwi.$logError("function cannot be null", instance);
    }
}

var modView = null;

/*
 *  ======== viewGetPriority ========
 */
function viewGetPriority(that, intNum)
{
    var priority = 0;

    try {
        that.IPR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt8', isScalar: true}, 0xe000e400, 240, false);
        that.SHPR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt8', isScalar: true}, 0xe000ed18, 12, false);
    }
    catch (e) {
        print("Error: Problem fetching priorities: " + e.toString());
    }

    if (intNum >= 16) {
        priority = that.IPR[intNum-16];
    }
    else if (intNum >= 4) {
        priority = that.SHPR[intNum-4];
    }

    return priority;
}

/*
 *  ======== viewNvicFetch ========
 *  Called from viewInitModule()
 */
function viewNvicFetch(that)
{
    try {
        that.ISER = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000e100, 8, false);
        that.ISPR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000e200, 8, false);
        that.IABR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000e300, 8, false);
        that.ICSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed04, 1, false);
        that.STCSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000e010, 1, false);
        that.SHCSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed24, 1, false);
    }
    catch (e) {
        print("Error: Problem fetching NVIC: " + e.toString());
    }
}

/*
 *  ======== viewInitBasic ========
 *  Initialize the 'Basic' Task instance view.
 */
function viewInitBasic(view, obj)
{
    var Hwi = xdc.useModule('ti.sysbios.family.arm.m3.Hwi');
    var Program = xdc.useModule('xdc.rov.Program');
    var halHwi = xdc.useModule('ti.sysbios.hal.Hwi');
    var hwiModCfg = Program.getModuleConfig('ti.sysbios.family.arm.m3.Hwi');

    var subPriMasks = [0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff];

    var numPriTable = {
        "2" : {
            mask : 0x80,
            shift : 7
        },
        "4" : {
            mask : 0xc0,
            shift : 6
        },
        "8" : {
            mask : 0xe0,
            shift : 5
        },
        "16" : {
            mask : 0xf0,
            shift : 4
        },
        "32" : {
            mask : 0xf8,
            shift : 3
        },
        "64" : {
            mask : 0xfc,
            shift : 2
        },
        "128" : {
            mask : 0xfe,
            shift : 1
        },
        "256" : {
            mask : 0xff,
            shift : 0
        }
    }

    var pri = viewGetPriority(this, Math.abs(obj.intNum));

    mask = numPriTable[hwiModCfg.NUM_PRIORITIES].mask;

    shift = numPriTable[hwiModCfg.NUM_PRIORITIES].shift;

    view.priority = pri;

    if (hwiModCfg.priGroup + 1 > shift) {
        view.group = pri >> (hwiModCfg.priGroup + 1);
    }
    else {
        view.group = pri >> shift;
    }

    view.subPriority = (pri & subPriMasks[hwiModCfg.priGroup]) >> shift;

    view.halHwiHandle =  halHwi.viewGetHandle(obj.$addr);
    view.label = Program.getShortName(obj.$label);
    view.intNum = Math.abs(obj.intNum);

    if (obj.intNum >= 0) {
        view.type = "Dispatched";
    }
    else {
        if (view.priority < hwiModCfg.disablePriority) {
            view.type = "Zero Latency";
        }
        else {
            view.type = "Non Dispatched";
        }
    }

    var fxn = Program.lookupFuncName(Number(obj.fxn));
    if (fxn.length > 1) {
        view.fxn = fxn[1]; /* blow off FUNC16/32 */
    }
    else {
        view.fxn = fxn[0];
    }
    view.arg = obj.arg;
}

/*
 *  ======== viewInitDetailed ========
 *  Initialize the 'Detailed' Task instance view.
 */
function viewInitDetailed(view, obj)
{
    var Program = xdc.useModule('xdc.rov.Program');
    var Hwi = xdc.useModule('ti.sysbios.family.arm.m3.Hwi');
    var hwiModConfig = Program.getModuleConfig(Hwi.$name);
    var BIOS = xdc.useModule('ti.sysbios.BIOS');
    var biosModConfig = Program.getModuleConfig(BIOS.$name);

    /* Detailed view builds off basic view. */
    viewInitBasic(view, obj);

    view.irp = obj.irp;

    viewNvicFetch(this);

    var enabled = false;
    var active = false;
    var pending = false;

    if (view.intNum >= 16) {
        var index = (view.intNum-16) >> 5;
        var mask = 1 << ((view.intNum-16) & 0x1f);
        enabled = this.ISER[index] & mask;
        active = this.IABR[index] & mask;
        pending = this.ISPR[index] & mask;
    }
    else {
        switch(view.intNum) {
            case 15: /* SysTick */
                pending = this.ICSR & 0x100000000;
                enabled = this.STCSR & 0x00000002;
                active = this.SHCSR & 0x00000800;
                break;
            default:
                view.status = "unknown";
                return;
                break;
        }
    }

    if (enabled) {
        view.status = "Enabled";
    }
    else {
        view.status = "Disabled";
    }

    if (active) {
        view.status += ", Active";
    }

    if (pending) {
        view.status += ", Pending";
    }

    if (biosModConfig.smpEnabled == true) {
        view.coreId = hwiModConfig.intAffinity[view.intNum];
    }
    else {
        view.coreId = 0;
    }
}

/*!
 *  ======== viewGetStackInfo ========
 */
function viewGetStackInfo()
{
    var IHwi = xdc.useModule('ti.sysbios.interfaces.IHwi');

    var stackInfo = new IHwi.StackInfo();

    /* Fetch the Hwi stack */
    try {
        if (Program.build.target.$name.match(/iar/)) {
            var size = Program.getSymbolValue("CSTACK$$Length");
            if (size == -1) {

                size = Program.getSymbolValue("CSTACK$$Limit")
                           - Program.getSymbolValue("CSTACK$$Base");
            }
            var stackBase = Program.getSymbolValue("CSTACK$$Base");            
        }
        else {
            var size = Program.getSymbolValue("__STACK_SIZE");
	    if (size == -1) {
		size = Program.getSymbolValue("__TI_STACK_SIZE");
	    }
            var stackBase = Program.getSymbolValue("__stack");
        }
        var stackData = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UChar', isScalar: true}, stackBase, size);
    }
    catch (e) {
        stackInfo.hwiStackSize = 0;     /* signal error to caller */
        return (stackInfo);
    }

    var index = 0;

    /*
     * The stack is filled with 0xbe.
     */
    while (stackData[index] == 0xbe) {
        index++;
    }

    stackInfo.hwiStackPeak = size - index;
    stackInfo.hwiStackSize = size;
    stackInfo.hwiStackBase = stackBase;

    return (stackInfo);
}

/*
 *  ======== viewDecodeNMI ========
 */
function viewDecodeNMI(excContext)
{
    return("NMI Exception");
}

/*
 *  ======== viewDecodeHardFault ========
 */
function viewDecodeHardFault(excContext)
{
    var fault = "Hard Fault: ";

    if (excContext.HFSR & 0x40000000) {
        fault += "FORCED: ";
        fault += viewDecodeUsageFault(excContext);
        fault += viewDecodeBusFault(excContext);
        fault += viewDecodeMemFault(excContext);
        return (fault);
    }
    else if (excContext.HFSR & 0x80000000) {
        fault += "DEBUGEVT: ";
        fault += viewDecodeDebugMon(excContext);
        return (fault);
    }
    else if (excContext.HFSR & 0x00000002) {
        fault += "VECTBL";
    }
    else {
        fault += "Unknown";
    }

    return (fault);
}

/*
 *  ======== viewDecodeMemFault ========
 */
function viewDecodeMemFault(excContext)
{
    var fault = ""

    if (excContext.MMFSR != 0) {

        fault = "MEMFAULT: ";
        if (excContext.MMFSR & 0x10) {
            fault += "MSTKERR";
        }
        else if (excContext.MMFSR & 0x08) {
            fault += "MUNSTKERR";
        }
        else if (excContext.MMFSR & 0x02) {
            fault += "DACCVIOL ";
            fault += "Data Access Error. Address = 0x" + Number(excContext.MMAR).toString(16);
        }
        else if (excContext.MMFSR & 0x01) {
            fault += "IACCVIOL ";
            fault += "Instruction Fetch Error. Address = 0x" + Number(excContext.MMAR).toString(16);
        }
        else {
            fault += "Unknown";
        }
    }
    return (fault);
}

/*
 *  ======== viewDecodeBusFault ========
 */
function viewDecodeBusFault(excContext)
{
    var fault = ""

    if (excContext.BFSR != 0) {

        fault = "BUSFAULT: ";

        if (excContext.BFSR & 0x10) {
            fault += "STKERR";
        }
        else if (excContext.BFSR & 0x08) {
            fault += "UNSTKERR";
        }
        else if (excContext.BFSR & 0x04) {
            fault += "IMPRECISERR";
        }
        else if (excContext.BFSR & 0x02) {
            fault += "PRECISERR.";
            fault += "Data Access Error. Address = 0x" + Number(excContext.BFAR).toString(16);
        }
        else if (excContext.BFSR & 0x01) {
            fault += "IBUSERR";
        }
        else {
            fault += "Unknown";
        }
    }
    return (fault);
}

/*
 *  ======== viewDecodeUsageFault ========
 */
function viewDecodeUsageFault(excContext)
{
    var fault = ""

    if (excContext.UFSR != 0) {
        fault = "USAGE: ";
        if (excContext.UFSR & 0x0001) {
            fault += "UNDEFINSTR";
        }
        else if (excContext.UFSR & 0x0002) {
            fault += "INVSTATE";
        }
        else if (excContext.UFSR & 0x0004) {
            fault += "INVPC";
        }
        else if (excContext.UFSR & 0x0008) {
            fault += "NOCP";
        }
        else if (excContext.UFSR & 0x0100) {
            fault += "UNALIGNED";
        }
        else if (excContext.UFSR & 0x0200) {
            fault += "DIVBYZERO";
        }
        else {
            fault += "Unknown";
        }
    }
    return (fault);
}

/*
 *  ======== viewDecodeSvCall ========
 */
function viewDecodeSvCall(excContext)
{
    return("SV Call Exception, pc = " + Number(excContext.pc).toString(16));
}

/*
 *  ======== viewDecodeDebugMon ========
 */
function viewDecodeDebugMon(excContext)
{
    var fault = "";

    if (excContext.DFSR != 0) {

        fault = "DEBUG: ";

        if (excContext.DFSR & 0x00000010) {
            fault += "EXTERNAL";
        }
        else if (excContext.DFSR & 0x00000008) {
            fault += "VCATCH";
        }
        else if (excContext.DFSR & 0x00000004) {
            fault += "DWTTRAP";
        }
        else if (excContext.DFSR & 0x00000002) {
            fault += "BKPT";
        }
        else if (excContext.DFSR & 0x00000001) {
            fault += "HALTED";
        }
        else {
            fault += "Unknown";
        }
    }
    return (fault);
}

/*
 *  ======== viewDecodeReserved ========
 */
function viewDecodeReserved(excContext, excNum)
{
    return ("Reserved vector: " + String(excNum));
}

/*
 *  ======== viewDecodeNoIsr ========
 */
function viewDecodeNoIsr(excContext, excNum)
{
    return ("Undefined Hwi: " + String(excNum));
}

/*
 *  ======== viewDecodeException ========
 */
function viewDecodeException(excContext)
{
    var Program = xdc.useModule('xdc.rov.Program');
    var Hwi = xdc.useModule('ti.sysbios.family.arm.m3.Hwi');

    var excNum = String(excContext.ICSR & 0xff);

    switch (excNum) {
        case "2":
            return (viewDecodeNMI(excContext));         /* NMI */
            break;
        case "3":
            return (viewDecodeHardFault(excContext));   /* Hard Fault */
            break;
        case "4":
            return (viewDecodeMemFault(excContext));    /* Mem Fault */
            break;
        case "5":
            return (viewDecodeBusFault(excContext));    /* Bus Fault */
            break;
        case "6":
            return (viewDecodeUsageFault(excContext));  /* Usage Fault */
            break;
        case "11":
            return (viewDecodeSvCall(excContext));      /* SVCall */
            break;
        case "12":
            return (viewDecodeDebugMon(excContext));    /* Debug Mon */
            break;
        case "7":
        case "8":
        case "9":
        case "10":
        case "13":
            return (viewDecodeReserved(excContext, excNum)); /* reserved */
            break;
        default:
            return (viewDecodeNoIsr(excContext, excNum));       /* no ISR */
            break;
    }
    return (null);
}

/*
 *  ======== viewCallStack ========
 */
function viewCallStack(excContext) {
    try {
        var CallStack = xdc.useModule('xdc.rov.CallStack');
        CallStack.clearRegisters();
    }
    catch (e) {
        return (null);
    }

    CallStack.setRegister("SP", Number(excContext["sp"]));
    CallStack.setRegister("R13", Number(excContext["sp"]));
    CallStack.setRegister("R14", Number(excContext["lr"]));
    CallStack.setRegister("PC", Number(excContext["pc"]));

    CallStack.setRegister("R0", Number(excContext["r0"]));
    CallStack.setRegister("R1", Number(excContext["r1"]));
    CallStack.setRegister("R2", Number(excContext["r2"]));
    CallStack.setRegister("R3", Number(excContext["r3"]));
    CallStack.setRegister("R4", Number(excContext["r4"]));
    CallStack.setRegister("R5", Number(excContext["r5"]));
    CallStack.setRegister("R6", Number(excContext["r6"]));
    CallStack.setRegister("R7", Number(excContext["r7"]));
    CallStack.setRegister("R8", Number(excContext["r8"]));
    CallStack.setRegister("R9", Number(excContext["r9"]));
    CallStack.setRegister("R10", Number(excContext["r10"]));
    CallStack.setRegister("R11", Number(excContext["r11"]));
    CallStack.setRegister("R12", Number(excContext["r12"]));

    /* fetch back trace string */
    var frames = CallStack.toText();

    /* break up into separate lines */
    frames = frames.split("\n");

    /*
     * Strip off "Unwind halted ... " from last frame
     */
    frames.length -= 1;

    for (var i = 0; i < frames.length; i++) {
        var line = frames[i];
        /* separate frame # from frame text a little */
        line = line.replace(" ", "    ");
        var file = line.substr(line.indexOf(" at ") + 4);
        file = file.replace(/\\/g, "/");
        file = file.substr(file.lastIndexOf("/")+1);
        if (file != "") {
            frames[i] = line.substring(0,
                                   line.indexOf(" at ") + 4);
            /* tack on file info */
            frames[i] += file;
        }
    }

    /*
     * Invert the frames[] array so that the strings become the index of a
     * new associative array.
     *
     * This is done because the TREE view renders the array index (field)
     * on the left and the array value on the right.
     *
     * At the same time, extract the "PC = ..." substrings and make them
     * be the value of the array who's index is the beginning of the
     * frame text.
     */
    var invframes = new Array();

    for (var i = 0; i < frames.length; i++) {
        invframes[frames[i].substring(0,frames[i].indexOf("PC")-1)] =
            frames[i].substr(frames[i].indexOf("PC"));
    }

    return (invframes);
}

/*
 *  ======== viewFillExceptionContext ========
 */
function viewFillExceptionContext(excContext)
{
   var Program = xdc.useModule('xdc.rov.Program');
   var CallStack = xdc.useModule('xdc.rov.CallStack');
   CallStack.fetchRegisters(["R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "PC", "xPSR"]);

   excContext.r0 = String(CallStack.getRegister("R0"));
   excContext.r1 = CallStack.getRegister("R1");
   excContext.r2 = CallStack.getRegister("R2");
   excContext.r3 = CallStack.getRegister("R3");
   excContext.r4 = CallStack.getRegister("R4");
   excContext.r5 = CallStack.getRegister("R5");
   excContext.r6 = CallStack.getRegister("R6");
   excContext.r7 = CallStack.getRegister("R7");
   excContext.r8 = CallStack.getRegister("R8");
   excContext.r9 = CallStack.getRegister("R9");
   excContext.r10 = CallStack.getRegister("R10");
   excContext.r11 = CallStack.getRegister("R11");
   excContext.r12 = CallStack.getRegister("R12");
   excContext.sp = CallStack.getRegister("R13");
   excContext.lr = CallStack.getRegister("R14");
   excContext.pc = CallStack.getRegister("PC");
   excContext.psr = CallStack.getRegister("xPSR");

   excContext.ICSR = Program.ptrToHex(Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed04, 1, false));
   excContext.MMFSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed04, 1, false);
   excContext.BFSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UChar', isScalar: true}, 0xe000ed29, 1, false);
   excContext.UFSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt16', isScalar: true}, 0xe000ed2a, 1, false);
   excContext.HFSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed2c, 1, false);
   excContext.DFSR = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed30, 1, false);
   excContext.MMAR = Program.ptrToHex(Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed34, 1, false));
   excContext.BFAR = Program.ptrToHex(Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed38, 1, false));
   excContext.AFSR = Program.ptrToHex(Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, 0xe000ed3c, 1, false));
}

/*
 *  ======== viewInitException ========
 */
function viewInitException()
{
    var Program = xdc.useModule('xdc.rov.Program');
    var Hwi = xdc.useModule('ti.sysbios.family.arm.m3.Hwi');
    var hwiModConfig = Program.getModuleConfig(Hwi.$name);

    var BIOS = xdc.useModule('ti.sysbios.BIOS');
    var biosModConfig = Program.getModuleConfig(BIOS.$name);

    if (biosModConfig.smpEnabled == true) {
        var Core = xdc.useModule('ti.sysbios.hal.Core');
        var coreModConfig = Program.getModuleConfig(Core.$name);
        var numCores = coreModConfig.numCores;
    }
    else {
        var numCores = 1;
    }

    var coreId;
    var excActive = false;

    try {
        var hwiRawView = Program.scanRawView('ti.sysbios.family.arm.m3.Hwi');
    }
    catch (e) {
        return null;
    }

    var excActive  = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt16', isScalar: true}, hwiRawView.modState.excActive, 2, false);

    try {
        var excContexts  = Program.fetchArray({type: 'xdc.rov.support.ScalarStructs.S_UInt', isScalar: true}, hwiRawView.modState.excContext, 2, false);
    }
    catch (e) {
        return null;
    }

    var obj = {};

    for (coreId = 0; coreId < numCores; coreId++) {
        if (excActive[coreId] != 0) {
	
	    if (hwiModConfig.excHandlerFunc == null) {
		var excContext = Program.fetchStruct(Hwi.ExcContext$fetchDesc,
                             hwiModConfig.vectorTableAddress, false);
		viewFillExceptionContext(excContext);
	    }
	    else {
                try {
                    var excContext = Program.fetchStruct(Hwi.ExcContext$fetchDesc,
                             excContexts[coreId], false);
                }
                catch (e) {
                    print(e);
                    return null;
                }
	    }

            var excDecode = {};
            excDecode["Decoded"] = {};
            excDecode.Decoded = viewDecodeException(excContext);

            var excCallStack = viewCallStack(excContext);

            if (biosModConfig.smpEnabled == true) {
                obj["Decoded exception, core " + String(coreId)] = excDecode;
                obj["Exception context " + String(coreId)] = excContext;
            }
            else {
                obj["Decoded exception"] = excDecode;
                obj["Exception context"] = excContext;
            }

            obj["Exception call stack"] = excCallStack;

        }
    }

    return (obj);
}

/*
 *  ======== viewInitModule ========
 */
function viewInitModule(view, mod)
{
    var Program = xdc.useModule('xdc.rov.Program');
    var halHwiModCfg = Program.getModuleConfig('ti.sysbios.hal.Hwi');
    var hwiModCfg = Program.getModuleConfig('ti.sysbios.family.arm.m3.Hwi');

    viewNvicFetch(this);
    view.activeInterrupt = String(this.ICSR & 0xff);
    view.pendingInterrupt = String((this.ICSR & 0xff000) >> 12);

    if ((view.activeInterrupt > 0) && (view.activeInterrupt < 14)) {
        view.exception = "Yes";
    }
    else {
        view.exception = "none";
    }

    view.options[0] = "Hwi.autoNestingSupport = ";
    view.options[1] = "Hwi.swiSupport = ";
    view.options[2] = "Hwi.taskSupport = ";
    view.options[3] = "Hwi.irpSupport = ";

    view.options[0] += hwiModCfg.dispatcherAutoNestingSupport ? "true" : "false";
    view.options[1] += hwiModCfg.dispatcherSwiSupport ? "true" : "false";
    view.options[2] += hwiModCfg.dispatcherTaskSupport ? "true" : "false";
    view.options[3] += hwiModCfg.dispatcherIrpTrackingSupport ? "true" : "false";

    var stackInfo = viewGetStackInfo();

    if (stackInfo.hwiStackSize == 0) {
        view.$status["hwiStackPeak"] =
        view.$status["hwiStackSize"] =
        view.$status["hwiStackBase"] = "Error fetching Hwi stack info!";
    }
    else {
        if (halHwiModCfg.initStackFlag) {
            view.hwiStackPeak = String(stackInfo.hwiStackPeak);
            view.hwiStackSize = stackInfo.hwiStackSize;
            view.hwiStackBase = "0x"+ stackInfo.hwiStackBase.toString(16);

            if (stackInfo.hwiStackPeak == stackInfo.hwiStackSize) {
                view.$status["hwiStackPeak"] = "Overrun!  ";
                /*                                  ^^  */
                /* (extra spaces to overcome right justify) */
            }
        }
        else {
            view.hwiStackPeak = "n/a - set Hwi.initStackFlag";
            view.hwiStackSize = stackInfo.hwiStackSize;
            view.hwiStackBase = "0x"+ stackInfo.hwiStackBase.toString(16);
        }
    }
}

/*
 *  ======== _enableExceptionSet ========
 *
 *  This function is called whenever enableException changes.
 */
function _enableExceptionSet(field, val)
{
    if (val == true) {
	if (Hwi.excHandlerFunc == Hwi.excHandlerMin) {
	    Hwi.excHandlerFunc = Hwi.excHandlerMax;
	}
    }
    else {
	if (Hwi.excHandlerFunc == Hwi.excHandlerMax) {
	    Hwi.excHandlerFunc = Hwi.excHandlerMin;
	}
    }
}

/*
 *  ======== _excHandlerFuncSet ========
 *
 *  This function is called whenever excHandlerFunc changes.
 *
 *  This "on set" function is here just to make xgconf update the
 *  excHandlerFunc field immediately whenever enableException is
 *  checked or unchecked.
 */
function _excHandlerFuncSet(field, val)
{
}
