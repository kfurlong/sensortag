#
#  Do not edit this file.  This file is generated from 
#  package.bld.  Any modifications to this file will be 
#  overwritten whenever makefiles are re-generated.
#
#  target compatibility key = iar.targets.arm.M3{1,0,7.40,2
#
ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3: package/package_ti.sysbios.heaps.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.srm3: package/package_ti.sysbios.heaps.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3: HeapBuf.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.srm3: HeapBuf.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3: HeapMem.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.srm3: HeapMem.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3: HeapMultiBuf.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.srm3: HeapMultiBuf.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3: HeapNull.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.srm3: HeapNull.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3: HeapTrack.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.srm3: HeapTrack.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

ifeq (,$(MK_NOGENDEPS))
-include package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3.dep
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3.dep: ;
endif

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3: HeapCallback.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.srm3: | .interfaces
package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.srm3: HeapCallback.c lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clrm3 $< ...
	LC_ALL=C $(iar.targets.arm.M3.rootDir)/bin/iccarm  --silent --aeabi --cpu=Cortex-M3 --diag_suppress=Pa050,Go005 --endian=little -e --thumb  -Dxdc_target_name__=M3 -Dxdc_target_types__=iar/targets/arm/std.h -Dxdc_bld__profile_debug -Dxdc_bld__vers_1_0_7_40_2 --debug --dlib_config $(iar.targets.arm.M3.rootDir)/inc/c/DLib_Config_Normal.h  -Dti_sysbios_Build_useHwiMacros -Dti_sysbios_BIOS_smpEnabled__D=FALSE  $(XDCINCS)  -o $@  $<
	
	-@$(FIXDEP) $@.dep $@.dep
	

clean,rm3 ::
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.srm3
	-$(RM) package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.srm3

lib/sysbios/debug/ti.sysbios.heaps.arm3: package/lib/lib/sysbios/debug/ti.sysbios.heaps/package/package_ti.sysbios.heaps.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapBuf.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMem.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapMultiBuf.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapNull.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapTrack.orm3 package/lib/lib/sysbios/debug/ti.sysbios.heaps/HeapCallback.orm3 lib/sysbios/debug/ti.sysbios.heaps.arm3.mak

clean::
	-$(RM) lib/sysbios/debug/ti.sysbios.heaps.arm3.mak
