[#ftl]
/**
 ******************************************************************************
  * @file    bsp_driver_sram.h (based on stm32469i_eval_sram.h)
  * @brief   This file contains the common defines and functions prototypes for  
  *          the bsp_driver_sram.c driver.
  ******************************************************************************
  *
  * COPYRIGHT(c) ${year} STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */
  
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F4XX_SRAM_H
#define __STM32F4XX_SRAM_H

#ifdef __cplusplus
 extern "C" {
#endif 

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx_hal.h"
#include "stm32f4xx_hal_sram.h"

[#-- SWIPdatas is a list of SWIPconfigModel --]  
[#list SWIPdatas as SWIP]  

[#if SWIP.defines??]
	[#list SWIP.defines as definition]	
/*---------- Handle for SRAM -----------*/
#define ${definition.name} #t#t ${definition.value} 
[#if definition.description??]${definition.description} [/#if]
	[/#list]
[/#if]

[/#list]

/* USER CODE BEGIN 0 */

/** 
  * @}
  */     

/** @defgroup STM32469I-EVAL_SRAM_Exported_Constants STM32469I EVAL SRAM Exported Constants
  * @{
  */ 
#define SRAM_OK                ((uint8_t)0x00)
#define SRAM_ERROR             ((uint8_t)0x01)

#define SRAM_DEVICE_ADDR       ((uint32_t)0x64000000)

 /* SRAM device size in MBytes */
#define SRAM_DEVICE_SIZE       ((uint32_t)0x200000)

#define SRAM_MEMORY_WIDTH       FMC_NORSRAM_MEM_BUS_WIDTH_16
#define SRAM_BURSTACCESS        FMC_BURST_ACCESS_MODE_DISABLE
#define SRAM_WRITEBURST         FMC_WRITE_BURST_DISABLE
#define CONTINUOUSCLOCK_FEATURE FMC_CONTINUOUS_CLOCK_SYNC_ONLY

/* DMA definitions for SRAM DMA transfer */
#define __SRAM_DMAx_CLK_ENABLE   __HAL_RCC_DMA2_CLK_ENABLE
#define __SRAM_DMAx_CLK_DISABLE  __HAL_RCC_DMA2_CLK_DISABLE
#define SRAM_DMAx_CHANNEL        DMA_CHANNEL_0
#define SRAM_DMAx_STREAM         DMA2_Stream4
#define SRAM_DMAx_IRQn           DMA2_Stream4_IRQn
#define SRAM_DMAx_IRQHandler     DMA2_Stream4_IRQHandler

extern SRAM_HandleTypeDef _HSRAM;



/** @addtogroup STM32469I-EVAL_SRAM_Exported_Functions
  * @{
  */
uint8_t BSP_SRAM_Init(void);
uint8_t BSP_SRAM_ReadData(uint32_t uwStartAddress, uint16_t *pData, uint32_t uwDataSize);
uint8_t BSP_SRAM_ReadData_DMA(uint32_t uwStartAddress, uint16_t *pData, uint32_t uwDataSize);
uint8_t BSP_SRAM_WriteData(uint32_t uwStartAddress, uint16_t *pData, uint32_t uwDataSize);
uint8_t BSP_SRAM_WriteData_DMA(uint32_t uwStartAddress, uint16_t *pData, uint32_t uwDataSize);
void BSP_SRAM_DMA_IRQHandler(void);

/* USER CODE END 0 */
   
#ifdef __cplusplus
}
#endif

#endif /* __STM32F4XX_SRAM_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/