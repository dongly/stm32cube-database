[#ftl]
[#assign CPUCORE = cpucore?replace("ARM_CORTEX_","C")?replace("+","PLUS")]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    utilities_conf.h
  * @author  MCD Application Team
  * @brief   Header for configuration file to utilities
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
  ******************************************************************************
 */
/* USER CODE END Header */
[#--
[#if SWIPdatas??]
    [#list SWIPdatas as SWIP]
        [#if SWIP.defines??]
            [#list SWIP.defines as definition]
                ${definition.name}: ${definition.value}
            [/#list]
        [/#if]
    [/#list]
[/#if]
--]
[#assign SUBGHZ_APPLICATION = ""]
[#assign SECURE_PROJECTS = "0"]
[#if SWIPdatas??]
    [#list SWIPdatas as SWIP]
        [#if SWIP.defines??]
            [#list SWIP.defines as definition]
                [#if definition.name == "SUBGHZ_APPLICATION"]
                    [#assign SUBGHZ_APPLICATION = definition.value]
                [/#if]
            [/#list]
        [/#if]
    [/#list]
[/#if]

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __UTILITIES_CONF_H__
#define __UTILITIES_CONF_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
[#if CPUCORE == "CM0PLUS"]
#include "platform.h"
[/#if]
#include "cmsis_compiler.h"

/* definitions to be provided to "sequencer" utility */
#include "stm32_mem.h"
/* definition and callback for tiny_vsnprintf */
#include "stm32_tiny_vsnprintf.h"

[#if CPUCORE == "CM0PLUS"]
#include "mbmuxif_trace.h"
[#if (SECURE_PROJECTS == "1")]
#include "sys_privileged_wrap.h"
#include "stm32_seq.h"

[#if (SUBGHZ_APPLICATION == "SIGFOX_PUSHBUTTON") ]
#if defined(__ARMCC_VERSION)
#include "mapping_sbsfu.h"
#elif defined (__ICCARM__) || defined(__GNUC__)
#include "mapping_export.h"
#endif /* __ARMCC_VERSION */

[/#if]
[/#if]
[/#if]
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
[#if (CPUCORE == "CM0PLUS") || (CPUCORE == "CM4")]
/*---------------------------------------------------------------------------*/
/*                             sequencer configuration                       */
/*---------------------------------------------------------------------------*/
/**
  * @brief Sequencer flag reserved for future use
  */
#define UTIL_SEQ_RFU 0

[#if CPUCORE == "CM4"]
/**
  * @brief default number of tasks configured in sequencer
  */
#define SEQ_CONF_TASK_NBR    3

/**
  * @brief default value of priority task
  */
#define SEQ_CONF_PRIO_NBR    1

[#elseif CPUCORE == "CM0PLUS"]
/**
  * @brief default number of tasks configured in sequencer
  */
#define SEQ_CONF_TASK_NBR    4

/**
  * @brief default value of priority task
  */
#define SEQ_CONF_PRIO_NBR    1

[/#if]
[/#if]

[#if ((SUBGHZ_APPLICATION == "SIGFOX_AT_SLAVE") || (SUBGHZ_APPLICATION == "SIGFOX_PUSHBUTTON")) ]
/*---------------------------------------------------------------------------*/
/*                             eeprom configuration                       */
/*---------------------------------------------------------------------------*/

[#if (SECURE_PROJECTS == "1") && (CPUCORE == "CM0PLUS")]
/**
  * @brief Flash address
  */
#define HW_FLASH_ADDRESS                FLASH_BASE

/**
  * @brief Flash page size in bytes
  */
#define HW_FLASH_PAGE_SIZE              FLASH_PAGE_SIZE
[#else]
/**
  * @brief Flash address
  */
#define HW_FLASH_ADDRESS                (0x08000000UL)

/**
  * @brief Flash page size in bytes
  */
#define HW_FLASH_PAGE_SIZE              (0x00000800UL)
[/#if]

/**
  * @brief Flash width in bytes
  */
#define HW_FLASH_WIDTH                  8

/**
  * @brief Flash bank0 size in bytes
  */
#define CFG_EE_BANK0_SIZE               2*HW_FLASH_PAGE_SIZE

/**
  * @brief Maximum number of data that can be stored in bank0
  */
#define CFG_EE_BANK0_MAX_NB             EE_ID_COUNT<<2 /*from uint32 to byte*/

/* Unused Bank1 */
/**
  * @brief Flash bank1 size in bytes
  */
#define CFG_EE_BANK1_SIZE              0

/**
  * @brief Maximum number of data that can be stored in bank1
  */
#define CFG_EE_BANK1_MAX_NB            0

[#if (SECURE_PROJECTS == "1") && (CPUCORE == "CM0PLUS")]
/**
  * @brief EEPROM Flash address
  */
#define EE_BASE_ADRESS                  EE_DATASTORAGE_START
[#else]
/**
  * @brief EEPROM Flash address
  * @note last 2 sector of a 128kBytes device
  */
#define EE_BASE_ADRESS                  (0x0801D000UL)
[/#if]

[/#if]
#define VLEVEL_OFF    0  /*!< used to set UTIL_ADV_TRACE_SetVerboseLevel() (not as message param) */
#define VLEVEL_ALWAYS 0  /*!< used as message params, if this level is given
                              trace will be printed even when UTIL_ADV_TRACE_SetVerboseLevel(OFF) */
#define VLEVEL_L 1       /*!< just essential traces */
#define VLEVEL_M 2       /*!< functional traces */
#define VLEVEL_H 3       /*!< all traces */

#define TS_OFF 0         /*!< Log without TimeStamp */
#define TS_ON 1          /*!< Log with TimeStamp */

#define T_REG_OFF  0     /*!< Log without bitmask */

/* USER CODE BEGIN EC */

/* USER CODE END EC */
/* External variables --------------------------------------------------------*/
/* USER CODE BEGIN EV */

/* USER CODE END EV */

/* Exported macros -----------------------------------------------------------*/
/**
  * @brief Memory placement macro
  */
#if defined(__CC_ARM)
#define UTIL_PLACE_IN_SECTION( __x__ )  __attribute__((section (__x__), zero_init))
#elif defined(__ICCARM__)
#define UTIL_PLACE_IN_SECTION( __x__ )  __attribute__((section (__x__)))
#else  /* __GNUC__ */
#define UTIL_PLACE_IN_SECTION( __x__ )  __attribute__((section (__x__)))
#endif /* __CC_ARM | __ICCARM__ | __GNUC__ */

/**
  * @brief Memory alignment macro
  */
#undef ALIGN
#ifdef WIN32
#define ALIGN(n)
#else
#define ALIGN(n)             __attribute__((aligned(n)))
#endif /* WIN32 */

/**
  * @brief macro used to initialize the critical section
  */
#define UTIL_SEQ_INIT_CRITICAL_SECTION( )    UTILS_INIT_CRITICAL_SECTION()

/**
  * @brief macro used to enter the critical section
  */
#define UTIL_SEQ_ENTER_CRITICAL_SECTION( )   UTILS_ENTER_CRITICAL_SECTION()

/**
  * @brief macro used to exit the critical section
  */
#define UTIL_SEQ_EXIT_CRITICAL_SECTION( )    UTILS_EXIT_CRITICAL_SECTION()

[#if (SECURE_PROJECTS == "1") && (CPUCORE == "CM0PLUS") ]
/**
  * @brief macro to Enter CS used specifically by UTIL_SEQ_Run before going to Idle
  */
#define UTIL_SEQ_ENTER_CRITICAL_SECTION_IDLE( )   SYS_PRIVIL_DisableIrqsAndRemainPriv()

/**
  * @brief macro to Exit CS used specifically by UTIL_SEQ_Run exiting from Idle
  */
#define UTIL_SEQ_EXIT_CRITICAL_SECTION_IDLE( )    SYS_PRIVIL_EnableIrqsAndGoUnpriv()

/**
  * @brief Security: Map UTIL_TIMER_IRQ on Sequencer Task (rather then Isr) such to run Unprivileged
  */
#define UTIL_TIMER_IRQ_MAP_INIT()     do{ UTIL_SEQ_RegTask((1 << CFG_SEQ_Task_UtilTimer_Process), UTIL_SEQ_RFU, UTIL_TIMER_IRQ_Handler);} while(0)

#define UTIL_TIMER_IRQ_MAP_PROCESS()  do{ UTIL_SEQ_SetTask(1 << CFG_SEQ_Task_UtilTimer_Process, CFG_SEQ_Prio_0); } while(0)

[/#if]
/**
  * @brief Memset utilities interface to application
  */
#define UTIL_SEQ_MEMSET8( dest, value, size )   UTIL_MEM_set_8( dest, value, size )

/**
  * @brief macro used to initialize the critical section
  */
#define UTILS_INIT_CRITICAL_SECTION()

[#if (SECURE_PROJECTS == "1") && (CPUCORE == "CM0PLUS") ]
/**
  * @brief macro used to enter the critical section
  */
#define UTILS_ENTER_CRITICAL_SECTION() uint32_t nvic_iser_state= SYS_PRIVIL_EnterCriticalSection()

/**
  * @brief macro used to exit the critical section
  */
#define UTILS_EXIT_CRITICAL_SECTION()  SYS_PRIVIL_ExitCriticalSection(nvic_iser_state)
/**
  * @brief macro used to Enter critical section specifically for UTIL_LPM_EnterLowPower()
  */
#define UTIL_LPM_ENTER_CRITICAL_SECTION_ELP()
/**
  * @brief macro used to Exit critical section specifically for UTIL_LPM_EnterLowPower()
  */
#define UTIL_LPM_EXIT_CRITICAL_SECTION_ELP()
[#else]
/**
  * @brief macro used to enter the critical section
  */
#define UTILS_ENTER_CRITICAL_SECTION() uint32_t primask_bit= __get_PRIMASK();\
  __disable_irq()

/**
  * @brief macro used to exit the critical section
  */
#define UTILS_EXIT_CRITICAL_SECTION()  __set_PRIMASK(primask_bit)
[/#if]

/******************************************************************************
  * trace\advanced
  * the define option
  *    UTIL_ADV_TRACE_CONDITIONNAL shall be defined if you want use conditional function
  *    UTIL_ADV_TRACE_UNCHUNK_MODE shall be defined if you want use the unchunk mode
  *
  ******************************************************************************/

#define UTIL_ADV_TRACE_CONDITIONNAL                                                      /*!< not used */
#define UTIL_ADV_TRACE_UNCHUNK_MODE                                                      /*!< not used */
[#if CPUCORE == "CM0PLUS"]
#define UTIL_ADV_TRACE_MEMLOCATION                 UTIL_MEM_PLACE_IN_SECTION("MB_MEM2")  /*!< memory placement for trace buffer */
[/#if]
#define UTIL_ADV_TRACE_DEBUG(...)                                                        /*!< not used */
#define UTIL_ADV_TRACE_INIT_CRITICAL_SECTION( )    UTILS_INIT_CRITICAL_SECTION()         /*!< init the critical section in trace feature */
#define UTIL_ADV_TRACE_ENTER_CRITICAL_SECTION( )   UTILS_ENTER_CRITICAL_SECTION()        /*!< enter the critical section in trace feature */
#define UTIL_ADV_TRACE_EXIT_CRITICAL_SECTION( )    UTILS_EXIT_CRITICAL_SECTION()         /*!< exit the critical section in trace feature */
[#if ((SUBGHZ_APPLICATION == "LORA_AT_SLAVE") || (SUBGHZ_APPLICATION == "LORA_END_NODE"))]
#define UTIL_ADV_TRACE_TMP_BUF_SIZE                (512U)                                /*!< default trace buffer size */
#define UTIL_ADV_TRACE_TMP_MAX_TIMESTMAP_SIZE      (15U)                                 /*!< default trace timestamp size */
#define UTIL_ADV_TRACE_FIFO_SIZE                   (1024U)                               /*!< default trace fifo size */
[#else]
#define UTIL_ADV_TRACE_TMP_BUF_SIZE                (256U)                                /*!< default trace buffer size */
#define UTIL_ADV_TRACE_TMP_MAX_TIMESTMAP_SIZE      (15U)                                 /*!< default trace timestamp size */
#define UTIL_ADV_TRACE_FIFO_SIZE                   (512U)                                /*!< default trace fifo size */
[/#if]
#define UTIL_ADV_TRACE_MEMSET8( dest, value, size) UTIL_MEM_set_8((dest),(value),(size)) /*!< memset utilities interface to trace feature */
#define UTIL_ADV_TRACE_VSNPRINTF(...)              tiny_vsnprintf_like(__VA_ARGS__)      /*!< vsnprintf utilities interface to trace feature */

/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

#ifdef __cplusplus
}
#endif

#endif /*__UTILITIES_CONF_H__ */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
