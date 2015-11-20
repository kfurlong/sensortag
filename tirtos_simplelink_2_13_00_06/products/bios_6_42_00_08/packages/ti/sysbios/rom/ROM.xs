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
 *  ======== ROM.xs ========
 */

var ROM = null;

var BIOS = null;
var Build = null;

/*
 *  ======== module$meta$init ========
 */
function module$meta$init()
{
    /* Only process during "cfg" phase */
    if (xdc.om.$name != "cfg") {
        return;
    }

    ROM = this;

    Build = xdc.module('ti.sysbios.Build');

    /*
     * By convention, the Build module is pulled in and Build.buildROM set
     * to true by the ROM build config file before any module in this package
     * (ti.sysbios.rom) will have it's module$meta$init() func called.
     *
     * Therefore it is safe to assume that Build.buildROM has been actively
     * set to true when the ROM is being built, and set to false by default
     * when a ROM application is being built.
     */
    if (Build.buildROM == true) {
        Build.buildROMApp = false;
    }
    else {
        Build.buildROMApp = true;
    }

    var GetSet = xdc.module("xdc.services.getset.GetSet");
    GetSet.onSet(this, "romName", _setRomName);
}

/*
 *  ======== module$use ========
 */
function module$use()
{
}

/*
 *  ======== writeFile ========
 */
function writeFile(filename, content)
{
    var idx = 0;

    /* Open/Create file */
    var file = new java.io.FileWriter(filename);

    for(idx = 0; idx < content.length; idx++) {
        file.write(content[idx] + "\n");
    }
    file.flush();
}

/*
 *  ======== makeExternsFile ========
 */
function makeExternsFile(fileName)
{
    writeFile(fileName, ROM.excludedFuncs);
}

/*
 *  ======== getOtherLibs ========
 */
function getOtherLibs()
{
    var otherLibs = "";

    for (var i = 0; i < ROM.otherLibs.length; i++) {
        otherLibs += "-l \"" + ROM.otherLibs[i] + "\" ";
    }
    return (otherLibs);
}

/*
 *  ======== getLibDefs ========
 */
function getOtherLibDefs()
{
    var otherLibDefs = "";

    for (var i = 0; i < ROM.otherLibFuncs.length; i++) {
        otherLibDefs += " -D" + ROM.otherLibFuncs[i] + "=\\(*ti_sysbios_rom_ROM_" + ROM.otherLibFuncs[i] +"\\)";
    }

    return (otherLibDefs);
}

/*
 *  ======== getExternDefs ========
 */
function getExternDefs()
{
    var externDefs = "";

    for (var i = 0; i < ROM.excludedFuncs.length; i++) {
        externDefs += " -D" + ROM.excludedFuncs[i] + "=\\(*ti_sysbios_rom_ROM_" + ROM.excludedFuncs[i] +"\\)";
    }

    return (externDefs);
}

/*
 *  ======== getGeneratedDefs ========
 */
function getGeneratedDefs()
{
    var generatedDefs = "";

    for (var i = 0; i < ROM.generatedFuncs.length; i++) {
        generatedDefs += " -D" + ROM.generatedFuncs[i] + "=\\(*ti_sysbios_rom_ROM_" + ROM.generatedFuncs[i] +"\\)";
    }

    return (generatedDefs);
}

/*
 *  ======== getConfigDefs ========
 */
function getConfigDefs()
{
    var configDefs = "";

    for (var i = 0; i < ROM.configDefs.length; i++) {
        configDefs += " " + ROM.configDefs[i];
    }

    return (configDefs);
}

/*
 *  ======== getExterns ========
 */
function getExterns()
{
    var externs = "";

    for (var i = 0; i < ROM.excludedFuncs.length; i++) {
        externs += ROM.excludedFuncs[i] + " ";
    }

    return (externs.trim());
}

/*
 *  ======== _setRomName ========
 */
function _setRomName(field, val)
{
    var RomModule = null;
    switch (ROM.romName) {
        case ROM.CC2650:
            RomModule = xdc.useModule('ti.sysbios.rom.cortexm.cc26xx.CC26xx');
            break;

        case ROM.CC2650_FLASH:
            RomModule = xdc.useModule('ti.sysbios.rom.cortexm.cc26xx.CC26xx');
            break;

        case ROM.CC1350:
            RomModule = xdc.useModule('ti.sysbios.rom.cortexm.cc13xx.CC13xx');
            break;

        case ROM.TM0SXX:
            RomModule = xdc.useModule('ti.sysbios.rom.cortexm.tm0sxx.TM0Sxx');
            break;

        case ROM.F28004x:
            RomModule = xdc.useModule('ti.sysbios.rom.c28.f28004x.F28004x');
            break;

	default:
	    ROM.$logError("Unrecognized ROM name.", ROM, "romName");
	    break;
    }

    if (RomModule != null) {
        if (Build.buildROMApp == true) {
            RomModule.loadAppConfig();
        }
    }
}
