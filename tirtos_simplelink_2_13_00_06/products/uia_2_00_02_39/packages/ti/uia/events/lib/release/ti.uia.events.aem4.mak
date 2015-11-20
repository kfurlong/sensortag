#
#  Do not edit this file.  This file is generated from 
#  package.bld.  Any modifications to this file will be 
#  overwritten whenever makefiles are re-generated.
#
#  target compatibility key = ti.targets.arm.elf.M4{1,0,5.2,2
#
ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4.dep
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4: package/package_ti.uia.events.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events/package -fr=./package/lib/lib/release/ti.uia.events/package -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events/package -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events/package -fr=./package/lib/lib/release/ti.uia.events/package
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.sem4: package/package_ti.uia.events.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events/package -fr=./package/lib/lib/release/ti.uia.events/package -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events/package -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events/package -fr=./package/lib/lib/release/ti.uia.events/package
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4.dep
package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4: UIAAppCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/UIAAppCtx.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAAppCtx.sem4: UIAAppCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAAppCtx.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAAppCtx.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4.dep
package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4: UIAChanCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/UIAChanCtx.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAChanCtx.sem4: UIAChanCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAChanCtx.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAChanCtx.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4.dep
package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4: UIAFrameCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/UIAFrameCtx.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAFrameCtx.sem4: UIAFrameCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAFrameCtx.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAFrameCtx.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4.dep
package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4: UIAThreadCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/UIAThreadCtx.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAThreadCtx.sem4: UIAThreadCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAThreadCtx.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAThreadCtx.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4.dep
package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4.dep: ;
endif

package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4: UIAUserCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c  -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C   -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

package/lib/lib/release/ti.uia.events/UIAUserCtx.sem4: | .interfaces
package/lib/lib/release/ti.uia.events/UIAUserCtx.sem4: UIAUserCtx.c lib/release/ti.uia.events.aem4.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4 -n $< ...
	$(ti.targets.arm.elf.M4.rootDir)/bin/armcl -c -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events -fc $<
	$(MKDEP) -a $@.dep -p package/lib/lib/release/ti.uia.events -s oem4 $< -C  -n -s --symdebug:none -qq -pdsw225 --endian=little -mv7M4 --float_support=vfplib --abi=eabi -eo.oem4 -ea.sem4  -ms -g  -Dxdc_target_name__=M4 -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_5_2_2 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4.rootDir)/include/rts -I$(ti.targets.arm.elf.M4.rootDir)/include  -fs=./package/lib/lib/release/ti.uia.events -fr=./package/lib/lib/release/ti.uia.events
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/release/ti.uia.events/UIAUserCtx.sem4: export C_DIR=
package/lib/lib/release/ti.uia.events/UIAUserCtx.sem4: PATH:=$(ti.targets.arm.elf.M4.rootDir)/bin/:$(PATH)

clean,em4 ::
	-$(RM) package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4
	-$(RM) package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.sem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAAppCtx.sem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAChanCtx.sem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAFrameCtx.sem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAThreadCtx.sem4
	-$(RM) package/lib/lib/release/ti.uia.events/UIAUserCtx.sem4

lib/release/ti.uia.events.aem4: package/lib/lib/release/ti.uia.events/package/package_ti.uia.events.oem4 package/lib/lib/release/ti.uia.events/UIAAppCtx.oem4 package/lib/lib/release/ti.uia.events/UIAChanCtx.oem4 package/lib/lib/release/ti.uia.events/UIAFrameCtx.oem4 package/lib/lib/release/ti.uia.events/UIAThreadCtx.oem4 package/lib/lib/release/ti.uia.events/UIAUserCtx.oem4 lib/release/ti.uia.events.aem4.mak

clean::
	-$(RM) lib/release/ti.uia.events.aem4.mak
