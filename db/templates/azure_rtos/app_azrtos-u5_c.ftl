[#ftl]
/* USER CODE BEGIN Header */ 
/**
  ******************************************************************************
  * @file    app_azure_rtos.c
  * @author  MCD Application Team
  * @brief   app_azure_rtos application implementation file
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

[#assign TX_ENABLED = "true"]
[#assign FX_ENABLED = "false"]
[#assign NX_ENABLED = "false"]
[#assign UX_HOST_ENABLED = "false"]
[#assign UX_DEVICE_ENABLED = "false"]
[#assign USBPD_DEVICE_ENABLED = "false"]
[#assign TOUCHSENSING_ENABLED = "false"]
[#assign GUI_INTERFACE_ENABLED = "false"]
[#assign PACK_IN_USE = "false"]
[#assign AZRTOS_APP_MEM_ALLOCATION_METHOD_VAL = "1"]
[#compress]
[#list SWIPdatas as SWIP]
[#if SWIP.defines??]
  [#list SWIP.defines as definition]
    [#assign value = definition.value]
    [#assign name = definition.name]
	
    [#if name == "FILEX_ENABLED" && value == "true"]
      [#assign FX_ENABLED = value]
    [/#if]    
	[#if name == "NETXDUO_ENABLED" && value == "true"]
      [#assign NX_ENABLED = value]
    [/#if]
	[#if name == "USBXDEVICE_ENABLED" && value == "true"]
      [#assign UX_DEVICE_ENABLED = value]
    [/#if]
	[#if name == "USBXHOST_ENABLED" && value == "true"]
      [#assign UX_HOST_ENABLED = value]
    [/#if]
	[#if name == "USBPD_ENABLED" && value == "true"]
      [#assign USBPD_DEVICE_ENABLED = value]
    [/#if]
	[#if name == "TSC_ENABLED" && value == "true"]
      [#assign TOUCHSENSING_ENABLED = value]
    [/#if]
    [#if name == "GUI_INTERFACE_ENABLED" && value == "true"]
      [#assign GUI_INTERFACE_ENABLED = value]
    [/#if]
	 [#if name.contains("AZRTOS_APP_MEM_ALLOCATION_METHOD")]
      [#assign AZRTOS_APP_MEM_ALLOCATION_METHOD_VAL = value]
    [/#if]
    [/#list]
[/#if]
[/#list]
[/#compress]

/* Includes ------------------------------------------------------------------*/
#include "app_azure_rtos.h"
[#if packs??]
[#assign PACK_IN_USE = "true"]
[#list packs as variables]
#include "app_${variables.value?lower_case}.h"
[/#list]
[/#if]
/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */

/* USER CODE END PV */

#if (USE_MEMORY_POOL_ALLOCATION == 1)
[#if TX_ENABLED == "true"]
/* USER CODE BEGIN TX_Pool_Buffer */
/* USER CODE END TX_Pool_Buffer */
static UCHAR tx_byte_pool_buffer[TX_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL tx_app_byte_pool;
[/#if]

[#if FX_ENABLED == "true"]
/* USER CODE BEGIN FX_Pool_Buffer */
/* USER CODE END FX_Pool_Buffer */
static UCHAR  fx_byte_pool_buffer[FX_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL fx_app_byte_pool;
[/#if]

[#if NX_ENABLED == "true"]
/* USER CODE BEGIN NX_Pool_Buffer */
/* USER CODE END NX_Pool_Buffer */
static UCHAR  nx_byte_pool_buffer[NX_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL nx_app_byte_pool;
[/#if]

[#if UX_HOST_ENABLED == "true"]
/* USER CODE BEGIN UX_HOST_Pool_Buffer */
/* USER CODE END UX_HOST_Pool_Buffer */
static UCHAR  ux_host_byte_pool_buffer[UX_HOST_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL ux_host_app_byte_pool;
[/#if]

[#if UX_DEVICE_ENABLED == "true"]
/* USER CODE BEGIN UX_Device_Pool_Buffer */
/* USER CODE END UX_Device_Pool_Buffer */
static UCHAR  ux_device_byte_pool_buffer[UX_DEVICE_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL ux_device_app_byte_pool;
[/#if]
[#if USBPD_DEVICE_ENABLED == "true"]
/* USER CODE BEGIN USBPD_Pool_Buffer */
/* USER CODE END USBPD_Pool_Buffer */
static UCHAR  usbpd_byte_pool_buffer[USBPD_DEVICE_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL usbpd_app_byte_pool;
[/#if]
[#if TOUCHSENSING_ENABLED == "true"]
/* USER CODE BEGIN TOUCHSENSING_Pool_Buffer */
/* USER CODE END TOUCHSENSING_Pool_Buffer */
static UCHAR  tsc_byte_pool_buffer[TOUCHSENSING_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL tsc_app_byte_pool;
[/#if]
[#if GUI_INTERFACE_ENABLED == "true"]
/* USER CODE BEGIN GUI_INTERFACE_Pool_Buffer */
/* USER CODE END GUI_INTERFACE_Pool_Buffer */
static UCHAR  gui_interface_byte_pool_buffer[GUI_INTERFACE_APP_MEM_POOL_SIZE];
static TX_BYTE_POOL gui_interface_app_byte_pool;
[/#if]

[#if packs??]
[#list packs as variables]
[@common.optinclude name=mxTmpFolder+"/RTOS_variables_${variables.name}.tmp"/]
[/#list]
[/#if]

#endif

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

  /**
  * @brief  Define the initial system.
  * @param  first_unused_memory : Pointer to the first unused memory
  * @retval None
  */
VOID tx_application_define(VOID *first_unused_memory)
{
  /* USER CODE BEGIN  tx_application_define_1*/

  /* USER CODE END  tx_application_define_1 */
#if (USE_MEMORY_POOL_ALLOCATION == 1)
  UINT status = TX_SUCCESS;
  VOID *memory_ptr;

[#if TX_ENABLED == "true" ]
  if (tx_byte_pool_create(&tx_app_byte_pool, "Tx App memory pool", tx_byte_pool_buffer, TX_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN TX_Byte_Pool_Error */

    /* USER CODE END TX_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN TX_Byte_Pool_Success */

    /* USER CODE END TX_Byte_Pool_Success */

    memory_ptr = (VOID *)&tx_app_byte_pool;
    status = App_ThreadX_Init(memory_ptr);
    if (status != TX_SUCCESS)
    {
      /* USER CODE BEGIN  App_ThreadX_Init_Error */
#t#t#twhile(1) 
#t#t#t{
#t#t#t}
      /* USER CODE END  App_ThreadX_Init_Error */
    }
    /* USER CODE BEGIN  App_ThreadX_Init_Success */
      
    /* USER CODE END  App_ThreadX_Init_Success */

  }
[/#if]
[#if FX_ENABLED == "true"]
  if (tx_byte_pool_create(&fx_app_byte_pool, "Fx App memory pool", fx_byte_pool_buffer, FX_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN FX_Byte_Pool_Error */

    /* USER CODE END FX_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN FX_Byte_Pool_Success */

    /* USER CODE END FX_Byte_Pool_Success */

    memory_ptr = (VOID *)&fx_app_byte_pool;
    status = MX_FileX_Init(memory_ptr);
    if (status != FX_SUCCESS)
    {
      /* USER CODE BEGIN  MX_FileX_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}      
      /* USER CODE END  MX_FileX_Init_Error */
    }
    /* USER CODE BEGIN  MX_FileX_Init_Success */
  
    /* USER CODE END  MX_FileX_Init_Success */
  }
  [/#if]

[#if NX_ENABLED == "true"]
  if (tx_byte_pool_create(&nx_app_byte_pool, "Nx App memory pool", nx_byte_pool_buffer, NX_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN NX_Byte_Pool_Error */

    /* USER CODE END NX_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN TX_Byte_Pool_Success */

    /* USER CODE END TX_Byte_Pool_Success */

    memory_ptr = (VOID *)&nx_app_byte_pool;
    status = MX_NetXDuo_Init(memory_ptr);
    if (status != NX_SUCCESS)
    {
      /* USER CODE BEGIN  MX_NetXDuo_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}      
      /* USER CODE END  MX_NetXDuo_Init_Error */
    }
    /* USER CODE BEGIN  MX_NetXDuo_Init_Success */
  
    /* USER CODE END MX_NetXDuo_Init_Success */

  }
[/#if]
[#if UX_HOST_ENABLED == "true"]
  if (tx_byte_pool_create(&ux_host_app_byte_pool, "Ux App memory pool", ux_host_byte_pool_buffer, UX_HOST_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN TX_Byte_Pool_Error */

    /* USER CODE END TX_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN UX_HOST_Byte_Pool_Success */

    /* USER CODE END UX_HOST_Byte_Pool_Success */

    memory_ptr = (VOID *)&ux_host_app_byte_pool;
    status = MX_USBX_Host_Init(memory_ptr);
    if (status != UX_SUCCESS)
    {
      /* USER CODE BEGIN  MX_USBX_Host_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}     
      /* USER CODE END  MX_USBX_Host_Init_Error */
    }
    /* USER CODE BEGIN  MX_USBX_Host_Init_Success */
      
    /* USER CODE END  MX_USBX_Host_Init_Success */ 
  }
[/#if]
[#if UX_DEVICE_ENABLED == "true"]
  if (tx_byte_pool_create(&ux_device_app_byte_pool, "Ux App memory pool", ux_device_byte_pool_buffer, UX_DEVICE_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN UX_Device_Byte_Pool_Error */

    /* USER CODE END UX_Device_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN UX_Device_Byte_Pool_Success */

    /* USER CODE END UX_Device_Byte_Pool_Success */

    memory_ptr = (VOID *)&ux_device_app_byte_pool;
    status = MX_USBX_Device_Init(memory_ptr);
    if (status != UX_SUCCESS)
    {
      /* USER CODE BEGIN  MX_USBX_Device_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}      
      /* USER CODE END  MX_USBX_Device_Init_Error */
    }
    /* USER CODE BEGIN  MX_USBX_Device_Init_Success */
      
    /* USER CODE END  MX_USBX_Device_Init_Success */
  }
[/#if]
[#if USBPD_DEVICE_ENABLED == "true"]
  if (tx_byte_pool_create(&usbpd_app_byte_pool, "USBPD App memory pool", usbpd_byte_pool_buffer, USBPD_DEVICE_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN USBPD_Byte_Pool_Error */

    /* USER CODE END USBPD_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN USBPD_Byte_Pool_Success */

    /* USER CODE END USBPD_Byte_Pool_Success */

    memory_ptr = (VOID *)&usbpd_app_byte_pool;
    status = MX_USBPD_Init(memory_ptr);
    if (status != USBPD_OK)
    {
      /* USER CODE BEGIN  MX_USBPD_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}
      /* USER CODE END  MX_USBPD_Init_Error */
    }
    /* USER CODE BEGIN  MX_USBPD_Init */
      
    /* USER CODE END  MX_USBPD_Init */
  }
[/#if]
[#if TOUCHSENSING_ENABLED == "true"]
  if (tx_byte_pool_create(&tsc_app_byte_pool, "TOUCHSENSING App memory pool", tsc_byte_pool_buffer, TOUCHSENSING_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN TOUCHSENSING_Byte_Pool_Error */

    /* USER CODE END TOUCHSENSING_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN TOUCHSENSING_Byte_Pool_Success */

    /* USER CODE END TOUCHSENSING_Byte_Pool_Success */

    memory_ptr = (VOID *)&tsc_app_byte_pool;
    status = MX_TOUCHSENSING_Init(memory_ptr);
    if (status != TSL_STATUS_OK)
    {
      /* USER CODE BEGIN  MX_TOUCHSENSING_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}
      /* USER CODE END  MX_TOUCHSENSING_Init_Error */
    }
    /* USER CODE BEGIN  MX_TOUCHSENSING_Init */
      
    /* USER CODE END  MX_TOUCHSENSING_Init */
  }
[/#if]
[#if GUI_INTERFACE_ENABLED == "true"]
  if (tx_byte_pool_create(&gui_interface_app_byte_pool, "GUI_INTERFACE App memory pool", gui_interface_byte_pool_buffer, GUI_INTERFACE_APP_MEM_POOL_SIZE) != TX_SUCCESS)
  {
    /* USER CODE BEGIN GUI_INTERFACE_Byte_Pool_Error */

    /* USER CODE END GUI_INTERFACE_Byte_Pool_Error */
  }
  else
  {
    /* USER CODE BEGIN GUI_INTERFACE_Byte_Pool_Success */

    /* USER CODE END GUI_INTERFACE_Byte_Pool_Success */

    memory_ptr = (VOID *)&gui_interface_app_byte_pool;
    status = GUI_InitOS(memory_ptr);
    if (status != USBPD_OK)
    {
      /* USER CODE BEGIN  MX_GUI_INTERFACE_Init_Error */
#t#t#twhile(1)
#t#t#t{
#t#t#t}
      /* USER CODE END  MX_GUI_INTERFACE_Init_Error */
    }
    /* USER CODE BEGIN  MX_GUI_INTERFACE_Init */

    /* USER CODE END  MX_GUI_INTERFACE_Init */
  }
[/#if]
[#if packs??]
[#list packs as variables]
[@common.optinclude name=mxTmpFolder+"/RTOS_pool_create_${variables.name}.tmp"/]
    if (MX_${variables.value}_Init(memory_ptr) != TX_SUCCESS)
    {
      /* USER CODE BEGIN  MX_${variables.name}_Init_Error */

      /* USER CODE END  MX_${variables.name}_Init_Error */
    }
    /* USER CODE BEGIN  MX_${variables.name}_Init_Success */

    /* USER CODE END  MX_${variables.name}_Init_Success */
  }
[/#list]
[/#if]
#else
/*
 * Using dynamic memory allocation requires to apply some changes to the linker file.
 * ThreadX needs to pass a pointer to the first free memory location in RAM to the tx_application_define() function,
 * using the "first_unused_memory" argument.
 * This require changes in the linker files to expose this memory location.
 * For EWARM add the following section into the .icf file:
     place in RAM_region    { last section FREE_MEM };
 * For MDK-ARM
     - either define the RW_IRAM1 region in the ".sct" file
     - or modify the line below in "tx_low_level_initilize.s to match the memory region being used
        LDR r1, =|Image$$RW_IRAM1$$ZI$$Limit|

 * For STM32CubeIDE add the following section into the .ld file:
     ._threadx_heap :
       {
          . = ALIGN(8);
          __RAM_segment_used_end__ = .;
          . = . + 64K;
          . = ALIGN(8);
        } >RAM_D1 AT> RAM_D1
    * The simplest way to provide memory for ThreadX is to define a new section, see ._threadx_heap above.
    * In the example above the ThreadX heap size is set to 64KBytes.
    * The ._threadx_heap must be located between the .bss and the ._user_heap_stack sections in the linker script.
    * Caution: Make sure that ThreadX does not need more than the provided heap memory (64KBytes in this example).
    * Read more in STM32CubeIDE User Guide, chapter: "Linker script".

 * The "tx_initialize_low_level.s" should be also modified to enable the "USE_DYNAMIC_MEMORY_ALLOCATION" flag.
 */

  /* USER CODE BEGIN DYNAMIC_MEM_ALLOC */
  (void)first_unused_memory;
  /* USER CODE END DYNAMIC_MEM_ALLOC */
#endif

}
