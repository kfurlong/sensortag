/*
 *  Do not modify this file; it is automatically 
 *  generated and any modifications will be overwritten.
 *
 * @(#) xdc-A71
 */

/*
 * ======== GENERATED SECTIONS ========
 *     
 *     PROLOGUE
 *     INCLUDES
 *     
 *     INTERNAL DEFINITIONS
 *     MODULE-WIDE CONFIGS
 *     VIRTUAL FUNCTIONS
 *     FUNCTION DECLARATIONS
 *     CONVERTORS
 *     SYSTEM FUNCTIONS
 *     
 *     EPILOGUE
 *     STATE STRUCTURES
 *     PREFIX ALIASES
 */


/*
 * ======== PROLOGUE ========
 */

#ifndef ti_uia_events_UIAThreadCtx__include
#define ti_uia_events_UIAThreadCtx__include

#ifndef __nested__
#define __nested__
#define ti_uia_events_UIAThreadCtx__top__
#endif

#ifdef __cplusplus
#define __extern extern "C"
#else
#define __extern extern
#endif

#define ti_uia_events_UIAThreadCtx___VERS 160


/*
 * ======== INCLUDES ========
 */

#include <xdc/std.h>

#include <xdc/runtime/xdc.h>
#include <xdc/runtime/Types.h>
#include <ti/uia/events/UIAThreadCtx__prologue.h>
#include <ti/uia/events/package/package.defs.h>

#include <xdc/runtime/Types.h>
#include <xdc/runtime/Diags.h>
#include <ti/uia/events/IUIACtx.h>
#include <xdc/runtime/Log.h>
#include <ti/uia/events/DvtTypes.h>


/*
 * ======== AUXILIARY DEFINITIONS ========
 */

/* IsLoggingEnabledFxn */
typedef ti_uia_events_IUIACtx_IsLoggingEnabledFxn ti_uia_events_UIAThreadCtx_IsLoggingEnabledFxn;


/*
 * ======== INTERNAL DEFINITIONS ========
 */


/*
 * ======== MODULE-WIDE CONFIGS ========
 */

/* Module__diagsEnabled */
typedef xdc_Bits32 CT__ti_uia_events_UIAThreadCtx_Module__diagsEnabled;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__diagsEnabled ti_uia_events_UIAThreadCtx_Module__diagsEnabled__C;

/* Module__diagsIncluded */
typedef xdc_Bits32 CT__ti_uia_events_UIAThreadCtx_Module__diagsIncluded;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__diagsIncluded ti_uia_events_UIAThreadCtx_Module__diagsIncluded__C;

/* Module__diagsMask */
typedef xdc_Bits16 *CT__ti_uia_events_UIAThreadCtx_Module__diagsMask;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__diagsMask ti_uia_events_UIAThreadCtx_Module__diagsMask__C;

/* Module__gateObj */
typedef xdc_Ptr CT__ti_uia_events_UIAThreadCtx_Module__gateObj;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__gateObj ti_uia_events_UIAThreadCtx_Module__gateObj__C;

/* Module__gatePrms */
typedef xdc_Ptr CT__ti_uia_events_UIAThreadCtx_Module__gatePrms;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__gatePrms ti_uia_events_UIAThreadCtx_Module__gatePrms__C;

/* Module__id */
typedef xdc_runtime_Types_ModuleId CT__ti_uia_events_UIAThreadCtx_Module__id;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__id ti_uia_events_UIAThreadCtx_Module__id__C;

/* Module__loggerDefined */
typedef xdc_Bool CT__ti_uia_events_UIAThreadCtx_Module__loggerDefined;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerDefined ti_uia_events_UIAThreadCtx_Module__loggerDefined__C;

/* Module__loggerObj */
typedef xdc_Ptr CT__ti_uia_events_UIAThreadCtx_Module__loggerObj;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerObj ti_uia_events_UIAThreadCtx_Module__loggerObj__C;

/* Module__loggerFxn0 */
typedef xdc_runtime_Types_LoggerFxn0 CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn0;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn0 ti_uia_events_UIAThreadCtx_Module__loggerFxn0__C;

/* Module__loggerFxn1 */
typedef xdc_runtime_Types_LoggerFxn1 CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn1;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn1 ti_uia_events_UIAThreadCtx_Module__loggerFxn1__C;

/* Module__loggerFxn2 */
typedef xdc_runtime_Types_LoggerFxn2 CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn2;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn2 ti_uia_events_UIAThreadCtx_Module__loggerFxn2__C;

/* Module__loggerFxn4 */
typedef xdc_runtime_Types_LoggerFxn4 CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn4;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn4 ti_uia_events_UIAThreadCtx_Module__loggerFxn4__C;

/* Module__loggerFxn8 */
typedef xdc_runtime_Types_LoggerFxn8 CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn8;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__loggerFxn8 ti_uia_events_UIAThreadCtx_Module__loggerFxn8__C;

/* Module__startupDoneFxn */
typedef xdc_Bool (*CT__ti_uia_events_UIAThreadCtx_Module__startupDoneFxn)(void);
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Module__startupDoneFxn ti_uia_events_UIAThreadCtx_Module__startupDoneFxn__C;

/* Object__count */
typedef xdc_Int CT__ti_uia_events_UIAThreadCtx_Object__count;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Object__count ti_uia_events_UIAThreadCtx_Object__count__C;

/* Object__heap */
typedef xdc_runtime_IHeap_Handle CT__ti_uia_events_UIAThreadCtx_Object__heap;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Object__heap ti_uia_events_UIAThreadCtx_Object__heap__C;

/* Object__sizeof */
typedef xdc_SizeT CT__ti_uia_events_UIAThreadCtx_Object__sizeof;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Object__sizeof ti_uia_events_UIAThreadCtx_Object__sizeof__C;

/* Object__table */
typedef xdc_Ptr CT__ti_uia_events_UIAThreadCtx_Object__table;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_Object__table ti_uia_events_UIAThreadCtx_Object__table__C;

/* isLoggingEnabledFxn */
#define ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn (ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn__C)
typedef ti_uia_events_IUIACtx_IsLoggingEnabledFxn CT__ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn__C;

/* ENABLEMASK */
#ifdef ti_uia_events_UIAThreadCtx_ENABLEMASK__D
#define ti_uia_events_UIAThreadCtx_ENABLEMASK (ti_uia_events_UIAThreadCtx_ENABLEMASK__D)
#else
#define ti_uia_events_UIAThreadCtx_ENABLEMASK (ti_uia_events_UIAThreadCtx_ENABLEMASK__C)
typedef xdc_Bits16 CT__ti_uia_events_UIAThreadCtx_ENABLEMASK;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_ENABLEMASK ti_uia_events_UIAThreadCtx_ENABLEMASK__C;
#endif

/* SYNCID */
#ifdef ti_uia_events_UIAThreadCtx_SYNCID__D
#define ti_uia_events_UIAThreadCtx_SYNCID (ti_uia_events_UIAThreadCtx_SYNCID__D)
#else
#define ti_uia_events_UIAThreadCtx_SYNCID (ti_uia_events_UIAThreadCtx_SYNCID__C)
typedef xdc_Bits16 CT__ti_uia_events_UIAThreadCtx_SYNCID;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_SYNCID ti_uia_events_UIAThreadCtx_SYNCID__C;
#endif

/* ctxChg */
#define ti_uia_events_UIAThreadCtx_ctxChg (ti_uia_events_UIAThreadCtx_ctxChg__C)
typedef xdc_runtime_Log_Event CT__ti_uia_events_UIAThreadCtx_ctxChg;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_ctxChg ti_uia_events_UIAThreadCtx_ctxChg__C;

/* ctxChgWithFunc */
#define ti_uia_events_UIAThreadCtx_ctxChgWithFunc (ti_uia_events_UIAThreadCtx_ctxChgWithFunc__C)
typedef xdc_runtime_Log_Event CT__ti_uia_events_UIAThreadCtx_ctxChgWithFunc;
__extern __FAR__ const CT__ti_uia_events_UIAThreadCtx_ctxChgWithFunc ti_uia_events_UIAThreadCtx_ctxChgWithFunc__C;


/*
 * ======== VIRTUAL FUNCTIONS ========
 */

/* Fxns__ */
struct ti_uia_events_UIAThreadCtx_Fxns__ {
    xdc_runtime_Types_Base* __base;
    const xdc_runtime_Types_SysFxns2 *__sysp;
    xdc_runtime_Types_SysFxns2 __sfxns;
};

/* Module__FXNS__C */
__extern const ti_uia_events_UIAThreadCtx_Fxns__ ti_uia_events_UIAThreadCtx_Module__FXNS__C;


/*
 * ======== FUNCTION DECLARATIONS ========
 */

/* Module_startup */
#define ti_uia_events_UIAThreadCtx_Module_startup( state ) (-1)

/* Module__startupDone__S */
xdc__CODESECT(ti_uia_events_UIAThreadCtx_Module__startupDone__S, "ti_uia_events_UIAThreadCtx_Module__startupDone__S")
__extern xdc_Bool ti_uia_events_UIAThreadCtx_Module__startupDone__S( void );

/* getCtxId__E */
#define ti_uia_events_UIAThreadCtx_getCtxId ti_uia_events_UIAThreadCtx_getCtxId__E
xdc__CODESECT(ti_uia_events_UIAThreadCtx_getCtxId__E, "ti_uia_events_UIAThreadCtx_getCtxId")
__extern xdc_UInt ti_uia_events_UIAThreadCtx_getCtxId__E( void );

/* getEnableOnValue__E */
#define ti_uia_events_UIAThreadCtx_getEnableOnValue ti_uia_events_UIAThreadCtx_getEnableOnValue__E
xdc__CODESECT(ti_uia_events_UIAThreadCtx_getEnableOnValue__E, "ti_uia_events_UIAThreadCtx_getEnableOnValue")
__extern xdc_UInt ti_uia_events_UIAThreadCtx_getEnableOnValue__E( void );

/* setEnableOnValue__E */
#define ti_uia_events_UIAThreadCtx_setEnableOnValue ti_uia_events_UIAThreadCtx_setEnableOnValue__E
xdc__CODESECT(ti_uia_events_UIAThreadCtx_setEnableOnValue__E, "ti_uia_events_UIAThreadCtx_setEnableOnValue")
__extern xdc_Void ti_uia_events_UIAThreadCtx_setEnableOnValue__E( xdc_UInt value );

/* isLoggingEnabled__E */
#define ti_uia_events_UIAThreadCtx_isLoggingEnabled ti_uia_events_UIAThreadCtx_isLoggingEnabled__E
xdc__CODESECT(ti_uia_events_UIAThreadCtx_isLoggingEnabled__E, "ti_uia_events_UIAThreadCtx_isLoggingEnabled")
__extern xdc_Bool ti_uia_events_UIAThreadCtx_isLoggingEnabled__E( xdc_UInt newThreadId );

/* setOldValue__E */
#define ti_uia_events_UIAThreadCtx_setOldValue ti_uia_events_UIAThreadCtx_setOldValue__E
xdc__CODESECT(ti_uia_events_UIAThreadCtx_setOldValue__E, "ti_uia_events_UIAThreadCtx_setOldValue")
__extern xdc_UInt ti_uia_events_UIAThreadCtx_setOldValue__E( xdc_UInt newValue );


/*
 * ======== CONVERTORS ========
 */

/* Module_upCast */
static inline ti_uia_events_IUIACtx_Module ti_uia_events_UIAThreadCtx_Module_upCast( void )
{
    return (ti_uia_events_IUIACtx_Module)&ti_uia_events_UIAThreadCtx_Module__FXNS__C;
}

/* Module_to_ti_uia_events_IUIACtx */
#define ti_uia_events_UIAThreadCtx_Module_to_ti_uia_events_IUIACtx ti_uia_events_UIAThreadCtx_Module_upCast

/* Module_upCast2 */
static inline ti_uia_events_IUIAEvent_Module ti_uia_events_UIAThreadCtx_Module_upCast2( void )
{
    return (ti_uia_events_IUIAEvent_Module)&ti_uia_events_UIAThreadCtx_Module__FXNS__C;
}

/* Module_to_ti_uia_events_IUIAEvent */
#define ti_uia_events_UIAThreadCtx_Module_to_ti_uia_events_IUIAEvent ti_uia_events_UIAThreadCtx_Module_upCast2


/*
 * ======== SYSTEM FUNCTIONS ========
 */

/* Module_startupDone */
#define ti_uia_events_UIAThreadCtx_Module_startupDone() ti_uia_events_UIAThreadCtx_Module__startupDone__S()

/* Object_heap */
#define ti_uia_events_UIAThreadCtx_Object_heap() ti_uia_events_UIAThreadCtx_Object__heap__C

/* Module_heap */
#define ti_uia_events_UIAThreadCtx_Module_heap() ti_uia_events_UIAThreadCtx_Object__heap__C

/* Module_id */
static inline CT__ti_uia_events_UIAThreadCtx_Module__id ti_uia_events_UIAThreadCtx_Module_id( void ) 
{
    return ti_uia_events_UIAThreadCtx_Module__id__C;
}

/* Module_hasMask */
static inline xdc_Bool ti_uia_events_UIAThreadCtx_Module_hasMask( void ) 
{
    return ti_uia_events_UIAThreadCtx_Module__diagsMask__C != NULL;
}

/* Module_getMask */
static inline xdc_Bits16 ti_uia_events_UIAThreadCtx_Module_getMask( void ) 
{
    return ti_uia_events_UIAThreadCtx_Module__diagsMask__C != NULL ? *ti_uia_events_UIAThreadCtx_Module__diagsMask__C : 0;
}

/* Module_setMask */
static inline xdc_Void ti_uia_events_UIAThreadCtx_Module_setMask( xdc_Bits16 mask ) 
{
    if (ti_uia_events_UIAThreadCtx_Module__diagsMask__C != NULL) *ti_uia_events_UIAThreadCtx_Module__diagsMask__C = mask;
}


/*
 * ======== EPILOGUE ========
 */

#include <ti/uia/events/UIAThreadCtx__epilogue.h>

#ifdef ti_uia_events_UIAThreadCtx__top__
#undef __nested__
#endif

#endif /* ti_uia_events_UIAThreadCtx__include */


/*
 * ======== STATE STRUCTURES ========
 */

#if defined(__config__) || (!defined(__nested__) && defined(ti_uia_events_UIAThreadCtx__internalaccess))

#ifndef ti_uia_events_UIAThreadCtx__include_state
#define ti_uia_events_UIAThreadCtx__include_state

/* Module_State */
struct ti_uia_events_UIAThreadCtx_Module_State {
    xdc_UInt mLastValue;
    xdc_UInt mEnableOnValue;
};

/* Module__state__V */
extern struct ti_uia_events_UIAThreadCtx_Module_State__ ti_uia_events_UIAThreadCtx_Module__state__V;

#endif /* ti_uia_events_UIAThreadCtx__include_state */

#endif


/*
 * ======== PREFIX ALIASES ========
 */

#if !defined(__nested__) && !defined(ti_uia_events_UIAThreadCtx__nolocalnames)

#ifndef ti_uia_events_UIAThreadCtx__localnames__done
#define ti_uia_events_UIAThreadCtx__localnames__done

/* module prefix */
#define UIAThreadCtx_IsLoggingEnabledFxn ti_uia_events_UIAThreadCtx_IsLoggingEnabledFxn
#define UIAThreadCtx_Module_State ti_uia_events_UIAThreadCtx_Module_State
#define UIAThreadCtx_isLoggingEnabledFxn ti_uia_events_UIAThreadCtx_isLoggingEnabledFxn
#define UIAThreadCtx_ENABLEMASK ti_uia_events_UIAThreadCtx_ENABLEMASK
#define UIAThreadCtx_SYNCID ti_uia_events_UIAThreadCtx_SYNCID
#define UIAThreadCtx_ctxChg ti_uia_events_UIAThreadCtx_ctxChg
#define UIAThreadCtx_ctxChgWithFunc ti_uia_events_UIAThreadCtx_ctxChgWithFunc
#define UIAThreadCtx_getCtxId ti_uia_events_UIAThreadCtx_getCtxId
#define UIAThreadCtx_getEnableOnValue ti_uia_events_UIAThreadCtx_getEnableOnValue
#define UIAThreadCtx_setEnableOnValue ti_uia_events_UIAThreadCtx_setEnableOnValue
#define UIAThreadCtx_isLoggingEnabled ti_uia_events_UIAThreadCtx_isLoggingEnabled
#define UIAThreadCtx_setOldValue ti_uia_events_UIAThreadCtx_setOldValue
#define UIAThreadCtx_Module_name ti_uia_events_UIAThreadCtx_Module_name
#define UIAThreadCtx_Module_id ti_uia_events_UIAThreadCtx_Module_id
#define UIAThreadCtx_Module_startup ti_uia_events_UIAThreadCtx_Module_startup
#define UIAThreadCtx_Module_startupDone ti_uia_events_UIAThreadCtx_Module_startupDone
#define UIAThreadCtx_Module_hasMask ti_uia_events_UIAThreadCtx_Module_hasMask
#define UIAThreadCtx_Module_getMask ti_uia_events_UIAThreadCtx_Module_getMask
#define UIAThreadCtx_Module_setMask ti_uia_events_UIAThreadCtx_Module_setMask
#define UIAThreadCtx_Object_heap ti_uia_events_UIAThreadCtx_Object_heap
#define UIAThreadCtx_Module_heap ti_uia_events_UIAThreadCtx_Module_heap
#define UIAThreadCtx_Module_upCast ti_uia_events_UIAThreadCtx_Module_upCast
#define UIAThreadCtx_Module_to_ti_uia_events_IUIACtx ti_uia_events_UIAThreadCtx_Module_to_ti_uia_events_IUIACtx
#define UIAThreadCtx_Module_upCast2 ti_uia_events_UIAThreadCtx_Module_upCast2
#define UIAThreadCtx_Module_to_ti_uia_events_IUIAEvent ti_uia_events_UIAThreadCtx_Module_to_ti_uia_events_IUIAEvent

#endif /* ti_uia_events_UIAThreadCtx__localnames__done */
#endif
