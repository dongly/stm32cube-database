[#ftl]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    sys_app.h
  * @author  MCD Application Team
  * @brief   Function prototypes for sys_app.c file
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
[#assign CPUCORE = cpucore?replace("ARM_CORTEX_","C")?replace("+","PLUS")]
[#assign SUBGHZ_APPLICATION = ""]
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
#ifndef __SYS_APP_H__
#define __SYS_APP_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
[#if (CPUCORE != "")]
#include "platform.h"
#include "mbmux_table.h"
[#else]
#include "stdint.h"
[/#if]
[#if ((SUBGHZ_APPLICATION != "LORA_USER_APPLICATION") && (SUBGHZ_APPLICATION != "SUBGHZ_USER_APPLICATION") && (SUBGHZ_APPLICATION != "SIGFOX_USER_APPLICATION"))]
#include "sys_conf.h"
#include "stm32_adv_trace.h"
[/#if]
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported defines ----------------------------------------------------------*/
[#if (CPUCORE == "CM0PLUS")]
/* currently not supported */
/* #define ALLOW_KMS_VIA_MBMUX */

[/#if]
/* USER CODE BEGIN ED */

/* USER CODE END ED */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* External variables --------------------------------------------------------*/
/* USER CODE BEGIN EV */

/* USER CODE END EV */

/* Exported macros -----------------------------------------------------------*/
[#if ((SUBGHZ_APPLICATION != "LORA_USER_APPLICATION") && (SUBGHZ_APPLICATION != "SUBGHZ_USER_APPLICATION") && (SUBGHZ_APPLICATION != "SIGFOX_USER_APPLICATION"))]
[#if (CPUCORE != "CM0PLUS")]
#define APP_PPRINTF(...)  do{ } while( UTIL_ADV_TRACE_OK \
                              != UTIL_ADV_TRACE_COND_FSend(VLEVEL_ALWAYS, T_REG_OFF, TS_OFF, __VA_ARGS__) ) /* Polling Mode */
[/#if]
#define APP_TPRINTF(...)   do{ {UTIL_ADV_TRACE_COND_FSend(VLEVEL_ALWAYS, T_REG_OFF, TS_ON, __VA_ARGS__);} }while(0); /* with timestamp */
#define APP_PRINTF(...)   do{ {UTIL_ADV_TRACE_COND_FSend(VLEVEL_ALWAYS, T_REG_OFF, TS_OFF, __VA_ARGS__);} }while(0);

#if defined (APP_LOG_ENABLED) && (APP_LOG_ENABLED == 1)
#define APP_LOG(TS,VL,...)   do{ {UTIL_ADV_TRACE_COND_FSend(VL, T_REG_OFF, TS, __VA_ARGS__);} }while(0);
#elif defined (APP_LOG_ENABLED) && (APP_LOG_ENABLED == 0) /* APP_LOG disabled */
#define APP_LOG(TS,VL,...)
#else
#error "APP_LOG_ENABLED not defined or out of range <0,1>"
#endif /* APP_LOG_ENABLED */
[#else]
/* USER CODE BEGIN APP_PRINT */
#define APP_PRINTF(...)
#define APP_LOG(TS,VL,...)
/* USER CODE END APP_PRINT */
[/#if]

/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
/**
[#if (CPUCORE != "CM0PLUS")]
  * @brief initialize the system (dbg pins, trace, mbmux, sys timer, LPM, ...)
[#elseif (CPUCORE == "CM0PLUS")]
  * @brief initialize MBMUXIF System and send a notification to Cm4 when ready
[/#if]
  */
void SystemApp_Init(void);

[#if (CPUCORE == "CM4")]
/**
  * @brief  Process System Notifications
  * @param  com_buf exchange buffer parameter
  */
void Process_Sys_Notif(MBMUX_ComParam_t *com_buf);

[/#if]
[#if ((SUBGHZ_APPLICATION == "LORA_END_NODE") || (SUBGHZ_APPLICATION == "LORA_AT_SLAVE") || (SUBGHZ_APPLICATION == "LORA_USER_APPLICATION"))]
[#if (CPUCORE == "") || (CPUCORE == "CM4")]
/**
  * @brief  callback to get the battery level in % of full charge (254 full charge, 0 no charge)
  * @retval battery level
  */
uint8_t GetBatteryLevel(void);

/**
  * @brief  callback to get the current temperature in the MCU
  * @retval temperature level
  */
uint16_t GetTemperatureLevel(void);

[/#if]
[#if (CPUCORE == "") || (CPUCORE == "CM0PLUS")]
/**
  * @brief  callback to get the board 64 bits unique ID
  * @param  id unique ID
  */
void GetUniqueId(uint8_t *id);

/**
  * @brief  callback to get the board 32 bits unique ID (LSB)
  * @retval devAddr Device Address
  */
uint32_t GetDevAddr(void);

[/#if]
[/#if]
[#if (CPUCORE == "CM0PLUS")]
/**
  * @brief Returns sec and msec based on the systime in use
  * @param buff to update with timestamp
  * @param size of updated buffer
  */
void TimestampNow(uint8_t *buff, uint16_t *size);

/**
  * @brief  Process System Command
  * @param  ComObj exchange buffer parameter
  */
void Process_Sys_Cmd(MBMUX_ComParam_t *ComObj);
#ifdef ALLOW_KMS_VIA_MBMUX /* currently not supported */
/**
  * @brief  Process KMS Command
  * @param  ComObj exchange buffer parameter
  */
void Process_Kms_Cmd(MBMUX_ComParam_t *ComObj);
#endif /* ALLOW_KMS_VIA_MBMUX */

[/#if]
/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

#ifdef __cplusplus
}
#endif

#endif /* __SYS_APP_H__ */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
