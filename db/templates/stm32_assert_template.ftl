[#ftl]
[#assign familyName=FamilyName?lower_case][#assign year="2018"][#if familyName="stm32h7"][#assign year="2017"][/#if][#if familyName="stm32g4" || familyName="stm32l5" ||familyName="stm32wb" ||familyName="stm32mp1"][#assign year="2019"][/#if][#if familyName="stm32wl"][#assign year="2020"][/#if][#if familyName="stm32u5"][#assign year="2021"][/#if] 
/**
  ******************************************************************************
  * @file    stm32_assert.h
  * @brief   STM32 assert file.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) ${year} STMicroelectronics. 
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32_ASSERT_H
#define __STM32_ASSERT_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/* Includes ------------------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
#ifdef  USE_FULL_ASSERT
/**
  * @brief  The assert_param macro is used for function's parameters check.
  * @param  expr: If expr is false, it calls assert_failed function
  *         which reports the name of the source file and the source
  *         line number of the call that failed.
  *         If expr is true, it returns no value.
  * @retval None
  */
 #define assert_param(expr) ((expr) ? (void)0U : assert_failed((uint8_t *)__FILE__, __LINE__))
/* Exported functions ------------------------------------------------------- */
  void assert_failed(uint8_t* file, uint32_t line);
#else
  #define assert_param(expr) ((void)0U)
#endif /* USE_FULL_ASSERT */

#ifdef __cplusplus
}
#endif

#endif /* __STM32_ASSERT_H */


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
