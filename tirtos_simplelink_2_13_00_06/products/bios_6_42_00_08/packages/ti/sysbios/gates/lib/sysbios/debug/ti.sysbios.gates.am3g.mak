#
#  Do not edit this file.  This file is generated from 
#  package.bld.  Any modifications to this file will be 
#  overwritten whenever makefiles are re-generated.
#
#  target compatibility key = gnu.targets.arm.M3{1,0,4.8,4
#
ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g: package/package_ti.sysbios.gates.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.sm3g: package/package_ti.sysbios.gates.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g: GateHwi.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.sm3g: GateHwi.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g: GateAll.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.sm3g: GateAll.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g: GateSwi.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.sm3g: GateSwi.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g: GateTask.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.sm3g: GateTask.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g: GateTest.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.sm3g: GateTest.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g: GateMutex.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.sm3g: GateMutex.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g: GateMutexPri.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.sm3g: GateMutexPri.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.sm3g: export LD_LIBRARY_PATH=

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g.dep
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g: GateSpinlock.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c  -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE -I/db/vtree/library/trees/zumaprod/zumaprod-g06/tirtos_simplelink_2_13_00_06/products/bios_6_42_00_08/packages/gnu/targets/arm//libs/install-native/arm-none-eabi/include   $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g: export LD_LIBRARY_PATH=

package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.sm3g: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.sm3g: GateSpinlock.c lib/sysbios/debug/ti.sysbios.gates.am3g.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clm3g -S $< ...
	$(gnu.targets.arm.M3.rootDir)/bin/arm-none-eabi-gcc -c -MD -MF $@.dep -x c -S -Wunused -Wunknown-pragmas -ffunction-sections -fdata-sections  -mcpu=cortex-m3 -mthumb -mabi=aapcs -g -Dfar= -D__DYNAMIC_REENT__  -g  -D_DEBUG_=1 -Dxdc_target_name__=M3 -Dxdc_target_types__=gnu/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_4_8_4 -g  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@ $<
	-@$(FIXDEP) $@.dep $@.dep
	
package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.sm3g: export LD_LIBRARY_PATH=

clean,m3g ::
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.sm3g
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.sm3g

lib/sysbios/debug/ti.sysbios.gates.am3g: package/lib/lib/sysbios/debug/ti.sysbios.gates/package/package_ti.sysbios.gates.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateHwi.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateAll.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSwi.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTask.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateTest.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutex.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateMutexPri.om3g package/lib/lib/sysbios/debug/ti.sysbios.gates/GateSpinlock.om3g lib/sysbios/debug/ti.sysbios.gates.am3g.mak

clean::
	-$(RM) lib/sysbios/debug/ti.sysbios.gates.am3g.mak
