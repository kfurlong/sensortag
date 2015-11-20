/* 
 *  Copyright (c) 2008 Texas Instruments and others.
 *  All rights reserved. This program and the accompanying materials
 *  are made available under the terms of the Eclipse Public License v1.0
 *  which accompanies this distribution, and is available at
 *  http://www.eclipse.org/legal/epl-v10.html
 * 
 *  Contributors:
 *      Texas Instruments - initial implementation
 * 
 * */
function init()
{
    switch (String(environment['os.name'])) {
        case 'Linux':
            xdc.loadPackage('xdc.tools.sg.swt_linux');
            break;

        case 'SunOS':
            xdc.loadPackage('xdc.tools.sg.swt_solaris');
            break;

        case 'Mac OS X':
            xdc.loadPackage('xdc.tools.sg.swt_macos');
            break;

        default:
            xdc.loadPackage('xdc.tools.sg.swt_win32');
            break;
    }
}
/*
 *  @(#) xdc.tools.sg; 1, 0, 0,517; 1-17-2015 17:06:08; /db/rtree/library/trees/xdcprod/xdcprod-r94/product/Linux/xdctools_3_25_05_94/packages/
 */

