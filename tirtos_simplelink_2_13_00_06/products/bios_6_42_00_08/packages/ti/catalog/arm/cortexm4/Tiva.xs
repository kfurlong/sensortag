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
 *  ======== Tiva.xs ========
 *
 */

var peripheralsTable = {};

peripheralsTable["0TIMERS"] = [
];

peripheralsTable["2TIMERS"] = [
    {
        factory: "ti.catalog.arm.peripherals.timers.Timer",
        params: {name: "Timer0", baseAddr: 0x40030000, intNum: 35}
    },
    {
        factory: "ti.catalog.arm.peripherals.timers.Timer",
        params: {name: "Timer1", baseAddr: 0x40031000, intNum: 37}
    }
];

peripheralsTable["3TIMERS"] = [];
for (var i = 0; i < peripheralsTable["2TIMERS"].length; i++) {
    peripheralsTable["3TIMERS"][i] = {};
    for (var prop in peripheralsTable["2TIMERS"][i]) {
        peripheralsTable["3TIMERS"][i][prop]
            = peripheralsTable["2TIMERS"][i][prop];
    }
}
peripheralsTable["3TIMERS"][i] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer2", baseAddr: 0x40032000, intNum: 39}
};

peripheralsTable["4TIMERS"] = [];
for (var i = 0; i < peripheralsTable["3TIMERS"].length; i++) {
    peripheralsTable["4TIMERS"][i] = {};
    for (var prop in peripheralsTable["3TIMERS"][i]) {
        peripheralsTable["4TIMERS"][i][prop]
            = peripheralsTable["3TIMERS"][i][prop];
    }
}
peripheralsTable["4TIMERS"][i] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer3", baseAddr: 0x40033000, intNum: 51}
};

peripheralsTable["6TIMERS"] = [];
for (var i = 0; i < peripheralsTable["4TIMERS"].length; i++) {
    peripheralsTable["6TIMERS"][i] = {};
    for (var prop in peripheralsTable["4TIMERS"][i]) {
        peripheralsTable["6TIMERS"][i][prop]
            = peripheralsTable["4TIMERS"][i][prop];
    }
}
peripheralsTable["6TIMERS"][i++] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer4", baseAddr: 0x40034000, intNum: 86}
};
peripheralsTable["6TIMERS"][i] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer5", baseAddr: 0x40035000, intNum: 108}
};

peripheralsTable["8TIMERS"] = [];
for (var i = 0; i < peripheralsTable["4TIMERS"].length; i++) {
    peripheralsTable["8TIMERS"][i] = {};
    for (var prop in peripheralsTable["4TIMERS"][i]) {
        peripheralsTable["8TIMERS"][i][prop]
            = peripheralsTable["4TIMERS"][i][prop];
    }
}
peripheralsTable["8TIMERS"][i++] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer4", baseAddr: 0x40034000, intNum: 79}
};
peripheralsTable["8TIMERS"][i++] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer5", baseAddr: 0x40035000, intNum: 81}
};
peripheralsTable["8TIMERS"][i++] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer6", baseAddr: 0x400E0000, intNum: 114}
};
peripheralsTable["8TIMERS"][i] = {
    factory: "ti.catalog.arm.peripherals.timers.Timer",
    params: {name: "Timer7", baseAddr: 0x400E1000, intNum: 116}
};

/*
 *  ======== instance$meta$init ========
 */
function instance$meta$init(revision)
{
    this.$private.realDevice = revision;

    var tableEntry;    
    /*
     * Define which actual devices correspond to the above defined
     * descriptor tables. Also, additional configurations important
     * to SYS/BIOS are made here.
     */
    if (this.$private.realDevice.match(/^LM4F294P9ZAD/)
        || this.$private.realDevice.match(/^LM4F29EP9ZAD/)
        || this.$private.realDevice.match(/^LM4F290P9PDT/)
        || this.$private.realDevice.match(/^LM4F292P9PDT/)
        || this.$private.realDevice.match(/^LM4F29CP9PDT/)
        || this.$private.realDevice.match(/^LM4F29DP9PDT/)
        || this.$private.realDevice.match(/^LM4F290P9ZAD/)
        || this.$private.realDevice.match(/^LM4F292P9ZAD/)
        || this.$private.realDevice.match(/^LM4F29CP9ZAD/)
        || this.$private.realDevice.match(/^LM4F29DP9ZAD/)
        || this.$private.realDevice.match(/^LM4F294P9PDT/)
        || this.$private.realDevice.match(/^LM4F29EP9PDT/)
        || this.$private.realDevice.match(/^LM4FB15P9ZAD/)
        || this.$private.realDevice.match(/^LM4FS01P9ZAD/)
        || this.$private.realDevice.match(/^TM4C129/)
        || this.$private.realDevice.match(/^TM4E12/)) {
        tableEntry = "8TIMERS";
    }
    else if (this.$private.realDevice.match(/^LM4/)
        || this.$private.realDevice.match(/^TM4C123/)
        || this.$private.realDevice.match(/^SC0/)
        || this.$private.realDevice.match(/^SC4/)) {
        tableEntry = "6TIMERS";
    }
    else if (this.$private.realDevice.match(/^TM4L/)) {
        tableEntry = "0TIMERS";
    }
    else {
        tableEntry = "4TIMERS";
    }

    if (peripheralsTable[tableEntry] != null) {
        for (var i = 0; i < peripheralsTable[tableEntry].length; i++) {
            var entry = peripheralsTable[tableEntry][i];
            var modName = entry.factory;
            var mod = xdc.useModule(modName);
            var params = entry.params;

            /* construct the create arguments */
            var args = [];
            args.push(params);

            /* construct the peripheral */
            this.peripherals[params.name] = mod.create.$apply(mod, args);
        }
    }
}

/*
 *  ======== Tiva.getMemoryMap ========
 *  Returns the memory map as seen by a program running on this device.
 */
function getMemoryMap(regs)
{
    return (null);
}
/*
 *  @(#) ti.catalog.arm.cortexm4; 1, 0, 0,; 4-24-2015 20:37:25; /db/ztree/library/trees/platform/platform-p07/src/
 */

