[#ftl]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file   app_fatfs.h
  * @brief  Header for fatfs applications
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __APP_FATFS_H
#define __APP_FATFS_H

[#compress]
[#assign usbMode = "0"]
[#assign userMode = "0"]
[#assign diskioCode = "0"]
[#list SWIPdatas as SWIP]
 [#if SWIP.defines??]
  [#list SWIP.defines as definition]
   [#if definition.name="_FS_FATFS_USB"]
    [#if definition.value="1"]
      [#assign usbMode = "1"]
    [/#if]
   [/#if]
   [#if definition.name="_FS_FATFS_USER"]
    [#if definition.value="1"]
      [#assign userMode = "1"]
    [/#if]
   [/#if]
   [#if definition.name="DISKIO_CODE"]
     [#if definition.value="1"]
      [#assign diskioCode = "1"]
     [/#if]
   [/#if]
  [/#list]
 [/#if]
[/#list]
[#if diskioCode = "1"]
  [#assign userMode = "2"]
[/#if]
/* Includes ------------------------------------------------------------------*/
#include "ff.h"
#include "ff_gen_drv.h"
[#if usbMode = "1"]
#include "usbh_diskio.h" /* defines USBH_Driver as external */ 
[/#if]
[#if userMode = "1"]
#include "user_diskio.h" /* defines USER_Driver as external */
[/#if]
[#if userMode = "2"]
#include "sd_diskio.h"   /* defines SD_Driver as external */
[/#if]
[/#compress]

#n
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
int32_t MX_FATFS_Init(void);
int32_t MX_FATFS_Process(void);
/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
/* USER CODE BEGIN Private defines */
#define APP_OK                      0
#define APP_ERROR                  -1
#define APP_SD_UNPLUGGED           -2
/* USER CODE END Private defines */

[#-- [@common.optinclude name=mxTmpFolder+"/fatfs_ext_vars.tmp"/] --]
[#if usbMode = "1"]
extern FATFS USBHFatFs;    /* File system object for USBH logical drive */
extern FIL USBHFile;       /* File  object for USBH */
extern char USBHPath[4];   /* USBH logical drive path */
[/#if]
[#if userMode = "1"]
extern FATFS USERFatFs;    /* File system object for USER logical drive */
extern FIL USERFile;       /* File  object for USER */
extern char USERPath[4];   /* USER logical drive path */
[/#if]
[#if userMode = "2"]
extern FATFS SDFatFs;    /* File system object for SD logical drive */
extern FIL SDFile;       /* File  object for SD */
extern char SDPath[4];   /* SD logical drive path */
[/#if]

#endif /*__APP_FATFS_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
