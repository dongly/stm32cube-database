[#ftl]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    app_filex.h
  * @author  MCD Application Team
  * @brief   FileX applicative header file
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __APP_FILEX_H__
#define __APP_FILEX_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "fx_api.h"
[#if SWIPdatas??]
[#list SWIPdatas as SWIP]
[#if SWIP.variables??]
[#list SWIP.variables as variable]
    [#assign value = variable.value]
    [#assign name = variable.name]
[#if name?contains("FX_SRAM_INTERFACE") && value == "1"]
#include "fx_stm32_sram_driver.h"
[/#if]
[#if name?contains("FX_SD_INTERFACE") && value == "1"]
#include "fx_stm32_sd_driver.h"
[/#if]
[#if name?contains("FX_LX_NOR_INTERFACE") && value == "1"]
#include "fx_stm32_levelx_nor_driver.h"
[/#if]
[#if name?contains("FX_LX_NAND_INTERFACE") && value == "1"]
#include "fx_stm32_levelx_nand_driver.h"
[/#if]
[#if name?contains("FX_CUSTOM_INTERFACE") && value == "1"]
#include "fx_stm32_custom_driver.h"
[/#if]
[#if name?contains("LX_NOR_USE_SIMULATOR_DRIVER") && value == "true"]
#include "lx_stm32_nor_simulator_driver.h"
[/#if]
[#if name?contains("LX_NOR_USE_CUSTOM_DRIVER") && value == "true"]
#include "lx_stm32_nor_custom_driver.h"
[/#if]
[#if name?contains("LX_NAND_USE_SIMULATOR_DRIVER") && value == "true"]
#include "lx_stm32_nand_simulator_driver.h"
[/#if]
[#if name?contains("LX_NAND_USE_CUSTOM_DRIVER") && value == "true"]
#include "lx_stm32_nand_custom_driver.h"
[/#if]
[#if name?contains("LX_NOR_USE_OSPI_DRIVER") && value == "true"]
#include "lx_stm32_ospi_driver.h"
[/#if]
[/#list]
[/#if]
[/#list]
[/#if]
/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
UINT MX_FileX_Init(VOID *memory_ptr);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */
#ifdef __cplusplus
}
#endif
#endif /* __APP_FILEX_H__ */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/