[#ftl]
/**
  ******************************************************************************
  * @file   fatfs.c
  * @brief  Code for fatfs applications
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

#include "fatfs.h"

[@common.optinclude name="Src/fatfs_vars.tmp"/]

[#list SWIPdatas as SWIP]  
[#if SWIP.defines??]
[#list SWIP.defines as definition]
[#if definition.name="_MULTI_PARTITION"]                      
[#if definition.value="1"]
/* USER CODE BEGIN VolToPart */
/* Volume - Partition resolution table should be user defined in case of Multiple partition */
/* When multi-partition feature is enabled (1), each logical drive number is bound to arbitrary physical drive and partition
listed in the VolToPart[] */
PARTITION VolToPart[];
/* USER CODE END VolToPart */  
[/#if] 
[/#if]
[/#list]
[/#if]
[/#list]

/* USER CODE BEGIN Variables */

/* USER CODE END Variables */    

void MX_FATFS_Init(void) 
{
[@common.optinclude name="Src/fatfs_HalInit.tmp"/]

#t/* USER CODE BEGIN Init */
#t/* additional user code for init */     
#t/* USER CODE END Init */
}

[#list SWIPdatas as SWIP]  
[#if SWIP.defines??]
[#list SWIP.defines as definition]
[#if definition.name="_FS_NORTC"]                           
[#if definition.value="0"]
/**
  * @brief  Gets Time from RTC 
  * @param  None
  * @retval Time in DWORD
  */
DWORD get_fattime(void)
{
#t/* USER CODE BEGIN get_fattime */
  return 0;
#t/* USER CODE END get_fattime */  
}
[/#if] 
[/#if]
[/#list]
[/#if]
[/#list]

/* USER CODE BEGIN Application */
     
/* USER CODE END Application */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
