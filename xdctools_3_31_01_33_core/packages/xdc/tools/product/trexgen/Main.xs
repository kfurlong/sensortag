/* 
 *  Copyright (c) 2009 Texas Instruments and others.
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
 *  ======== run ========
 */
function run(cmdr, args)
{
    /* Check for required command line parameters */
    if (this.productModule == undefined) {
        cmdr.usage();
        return (null);
    }

   /* Create an options object to pass to function when generating the
    * resources folder
    */
    var opts = {};
    for (var p in this) {
        opts[p] = this[p];
    }

    opts.productSchema = xdc.useModule(this.productModule);
    opts.outDir = (opts.outputDir != null) ?
        opts.outputDir:
        this.productDir;

    opts.moduleDir = opts.productSchema.$package.$spec.getBaseDir();
    _checkConfigs(opts.productSchema);

    /* Add product repositories to the front of the package path */
    var curPathArr = xdc.curPath().split(';');
    var xdcPathArr = java.lang.reflect.Array.newInstance(
        java.lang.String, opts.productSchema.repositoryArr.length
            + curPathArr.length);
    var i = 0;
    for each (var r in opts.productSchema.repositoryArr) {
        var rep = new java.io.File(opts.productDir + "/" + r);
        xdcPathArr[i++] =  rep.getAbsolutePath();
    }
    for each (var p in curPathArr) {
        xdcPathArr[i++] = p;
    }

    /* Update package path with product repositories */
    xdc.$$private.Env.setPath(xdcPathArr);

    /* Get examples information */
    var templateInfo = getTemplateInfo(opts, opts.outDir);

    /*
     * Generate .projectspec and .description files
     */
    createProjectSpec(opts, opts.outDir, templateInfo);

     /* create Content.xml */
     var template = xdc.loadTemplate("xdc/tools/product/trexgen/content.xml.xdt");
     template.genFile(opts.outDir + "/" + "content.xml", this, [opts]);

     print("Generated projectspec files in resources folder: "
           + (new java.io.File(opts.outDir)).getCanonicalPath());

    return (null);
}

/*
 *  ======== _checkConfigs ========
 *  Check that product specification makes sense
 */
function _checkConfigs(productModule)
{
    /* Product name is required */
    if (productModule.name == undefined) {
        throw new Error("Product Name should be specified in module: "
                         + productModule + ". Set config parameter 'name'"
                         + " of module to the product name; e.g., 'XDCtools'");
    }

    /* Product id is required */
    if (productModule.id == undefined) {
        throw new Error("Product id should be specified in module: "
                        + productModule + ". Set config parameter 'id'"
                        + " of module to a unique product id;"
                        + " e.g., 'org.eclipse.rtsc.xdctools.product'");
    }

    /* Product version is required */
    if (productModule.version == undefined) {
        throw new Error("Product id should be specified in module: "
                        + productModule + ". Set config parameter 'version'"
                        + " of module; e.g., '3.16.02.31'");
    }

    /* Check version number format */
    var res = productModule.version.match(/(\d+)\.(\d+)\.(\d+)\.(\S+)/);
    if (res == null) {
        throw new Error("Product version '" + productModule.version
                        + "' specified in module '" + productModule
                        + "' does not match the format"
                        + " 'major.minor.service.qualifier' where"
                        + " 'major', 'minor', 'service' are integers"
                        + " and 'qualifier' is a string");
    }

    /* Repository location is required */
    if (productModule.repositoryArr == undefined) {
        throw new Error("Product repositories should be specified in module: "
                        + productModule
                        + ". Set config parameter 'repositoryArr'"
                        + " of module to repository location(s)"
                        + " relative to product installation directory");
    }

    /* Bundle name is required */
    if (productModule.bundleName == undefined) {
        throw new Error("Product bundle name should be specified in module: "
                        + productModule
                        + ". Set config parameter 'bundleName'"
                        + " of module to bundle name embedded in the top level"
                        + " folder of the product; e.g., for product folder"
                        + " 'xdctools_3_16_02_31' bundle name is 'xdctools'");
    }

    /* Ensure copyright and license are specified */
    if (productModule.copyRightNotice == undefined) {
        print("Warning: no copyright notice was specified, "
              + "assuming eclipse.org.  To change this, set the parameter "
              + "copyRightNotice in " + productModule.$name);
        productModule.copyRightNotice = 
            "Copyright Eclipse.org " + (new Date()).getFullYear();
    }

    if (productModule.licenseDescriptor.text == undefined) {
        print("Warning: no license text was specified, "
              + "assuming Eclipse EPL 1.0.  To change this, set the parameter "
              + "licenseDescriptor.text in " + productModule.$name);
        productModule.licenseDescriptor = {
            url:  "http://www.eclipse.org/legal/epl-v10.html",
            text: "Eclipse public license(EPL)"
        };
    }
}

/*
 *  ======== getTemplateInfo ========
 *  Create templateInfo variable with examples Array and
 *  corresponding applicability Array.
 */
function getTemplateInfo(opts, pluginDir)
{
    if (opts.productSchema.templateModule == undefined) {
        return null;
    }

    /* Create object to store template examples info along with
     * applicability data.
     */
    var templateInfo = new Object();

    var tmplMod = xdc.useModule(opts.productSchema.templateModule);
    templateInfo.module = tmplMod;

    /* get package path of this module */
    var index = opts.productSchema.templateModule.lastIndexOf('.');
    var pkgDir = opts.productSchema.templateModule.
        substring(0, index).replace(/\./g, '/');

    /* loop through templates and create list of examples */
    var descArr = new Array();
    for (var exampleNum = 0; exampleNum < tmplMod.templateArr.length; exampleNum++) {
        var elem = tmplMod.templateArr[exampleNum];
        var desc = new Object();
        desc.applicabilityArr = new Array();

        /* Change relative file paths to be package paths */
        for each (var f in elem.fileList) {
            if (f.path.indexOf(".") == 0) {
                f.path = pkgDir + f.path.substring(1, f.path.length);
            }
        }

        /* create Applicability entry for each example */
        for each (var filter in elem.filterArr) {
            var applicability = new Object();
            applicability.exceptArr = new Array();
            applicability.whenArr = new Array();
            for (var key in filter) {
                if (filter[key] == undefined) {
                    continue;
                }
                var fElem = new Object();
                fElem.key = key;
                if (filter[key].charAt(0) == "~") {
                    fElem.value = filter[key].substr(1);
                    applicability.exceptArr.push(fElem);
                }
                else {
                    fElem.value = filter[key];
                    applicability.whenArr.push(fElem);
                }
            }
            desc.applicabilityArr.push(applicability);
        }

        desc.templateId = opts.productSchema.id + ".example_" + exampleNum;

        descArr.push(desc);
    }

    templateInfo.descArr = descArr;

    return (templateInfo);
}

/*
 *  ======== createResources ========
 *  Creates the Group Directory Structure.
 *
 *  For each Directory/Group create a .description file for the directory and
 *  the projectspec files for each example within that group only if the
 *  example's option list specifies "TREX".
 */
function createProjectSpec(opts, resourceDir, templateInfo)
{
    var projectSpecTemplate = xdc.loadTemplate("xdc/tools/product/trexgen/projectspecTemplate.projectspec.xdt");

    if (templateInfo.module.templateGroupArr.length > 0) {

        for each (var element in templateInfo.module.templateGroupArr) {
            var paths = getGroupDirectoryPath(templateInfo.module.templateGroupArr, element);

            for  each (var path in paths) {

                /* var subFolder = composeDirectoryName(element.name);*/
                var destinationDirPath = resourceDir + '/' + path;

                var destinationDir = new java.io.File(destinationDirPath);
                if (!destinationDir.isDirectory()) {
                    destinationDir.mkdirs();
                    writeToDescriptionFile(element.name, element.description,
                                           destinationDir);
                }

                /* Generate Project Spec files */
                var index = 0;
                for each (var template in templateInfo.module.templateArr) {
                    var addToTRex = false;

                    /* Check elements options list for "TREX" */
                    if (template.options != undefined) {
                        var options = template.options.split(",");
                        for each (var option in options) {
                            if (option.equals("TREX")) {
                                addToTRex = true;
                            }
                        }
                    }

                    if (addToTRex) {
                        var descriptionArr = templateInfo.descArr[index];
                        for each (var group in template.groups) {
                            if (group == element.id) {
                                var name = composeDirectoryName(descriptionArr.templateId);

                                projectSpecTemplate.genFile(
                                    destinationDir + '/' + name + ".projectspec", 
                                    this,
                                    [template, descriptionArr, opts.productSchema.id, 
                                     templateInfo.module.templateGroupArr, opts.productSchema.templateModule]
                                );
                            }
                        }
                    }
                    index++;
                }
            }
        }
    }
}

/*
 *  ======== getGroupDirectoryPath ========
 *  Create array of all paths needed to represent the Group and sub Groups.
 */
function getGroupDirectoryPath(groupArray, element)
{
    if ((element.groups == null) || (element.groups.length == 0)) {
        return new Array(composeDirectoryName(""));
    }

    var groups = element.groups;
    var paths = new Array();
    var i = 0 ;
    for each (var id in groups) {
        var elem = getElement(groupArray, id);

        if (elem != null) {
            var subpaths = getGroupDirectoryPath(groupArray, elem);
            for each (var path in subpaths) {
                paths[i]= path + '/' + composeDirectoryName(element.name);
                i++;
            }
        }
    }

    return paths;
}

/*
 *  ======== getElement ========
 *  Find element with id from groupArray
 */

function getElement(groupArray, id)
{
    for each (var element in groupArray) {
        if (element.id.equals(id)) {
            return  element;
        }
    }

    return null;
}

/*
 *  ======== writeToDescriptionFile ========
 *  Write name and description into a dir.properties file within the
 *  destinationDir
 */
function writeToDescriptionFile(name, description, destinationDir)
{
    var indexFile = new java.io.File(destinationDir, "dir.properties");
    if (!indexFile.exists()) {
        var w = new java.io.PrintWriter(indexFile);
        w.println("name = " + name);
        w.println("description = " + description);
        w.close();
    }
}

/*
 *  ======== composeDirectoryName ========
 *  Create and return a string which can be used as a directory name from
 *  the input title string.
 */
function composeDirectoryName(title)
{
    var sb = new java.lang.StringBuilder();
    var atitle = new java.lang.String(title);

    var chars = atitle.trim().toCharArray();

    var toUpperCase = false;
    var toLowerCase = false;
    var lowered = false;

    for (var i = 0; i < chars.length; ++i) {
        var c = chars[i];

        if (java.lang.Character.isWhitespace(c)) {
            toUpperCase = true;
            continue;
        }

        if (!java.lang.Character.isJavaIdentifierPart(c)) {
            if ((c == ')' || c == ']') && i == chars.length-1) {
                continue;
            }
            else if (c == '-' || c == '/') {
                continue;
            }
            else if (c == '+') {
                c = 'p';
            }
            else {
                c = '_';
            }
        }

        if (c == '_') {
            toLowerCase = true;
        }

        if (java.lang.Character.isUpperCase(c) && lowered) {
            c = java.lang.Character.toLowerCase(c);
        }
        else {
            lowered = false;
        }

        if (toUpperCase) {
            c = java.lang.Character.toUpperCase(c);
            toUpperCase = false;
        }

        if (toLowerCase) {
            c = java.lang.Character.toLowerCase(c);
            toLowerCase = false;
            lowered = true;
        }

        if (sb.length() == 0) {
            c = java.lang.Character.toLowerCase(c);
            lowered = true;
        }

        sb.append(new java.lang.Character(c));
    }

    return sb.toString();
}
/*
 *  @(#) xdc.tools.product.trexgen; 1, 0, 0,52; 3-22-2015 09:31:49; /db/ztree/library/trees/xdctools/xdctools-f61x/src/
 */

