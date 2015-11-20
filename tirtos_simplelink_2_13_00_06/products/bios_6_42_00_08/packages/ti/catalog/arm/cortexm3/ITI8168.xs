/*
 *  Copyright (c) 2015 by Texas Instruments and others.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 *
 *  Contributors:
 *      Texas Instruments - initial implementation
 *
 * */

/*
 *  ======== ITI8168.xs ========
 *
 */

/*
 *  ======== ITI8168.getMemoryMap ========
 *  Returns the memory map as seen by a program running on this device
 *  when the registers are set as specified by the regs hash.
 */
function getMemoryMap(regs)
{
    return (this.memMap);
}

/*
 *  ======== ITI8168.instance$meta$init ========
 */
function instance$meta$init()
{
    var HDVICP2 = xdc.useModule("ti.catalog.peripherals.hdvicp2.HDVICP2");

    this.hdvicp0 = HDVICP2.create({ name: "HDVICP0", baseAddr: 0x58000000, intNum:38});
    this.hdvicp1 = HDVICP2.create({ name: "HDVICP1", baseAddr: 0x5A000000, intNum:35});
    this.hdvicp2 = HDVICP2.create({ name: "HDVICP2", baseAddr: 0x53000000, intNum:32});
}
/*
 *  @(#) ti.catalog.arm.cortexm3; 1, 0, 0,; 4-24-2015 20:37:24; /db/ztree/library/trees/platform/platform-p07/src/
 */

