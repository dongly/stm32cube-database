[#ftl]       [#-- TO UPDATE: NOT READY !!!! --]
[#assign familyName=FamilyName?lower_case]
[#assign use_rtos=0]
[#if SWIPdatas??]
[#list SWIPdatas as SWIP]  
[#if SWIP.defines??]
 [#list SWIP.defines as definition] 
  [#if definition.name="_FS_REENTRANT"]
   [#if definition.value="1"]
    [#assign use_rtos=1]
   [/#if]
  [/#if]
 [/#list]
[/#if]
[/#list]
[/#if]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    sd_diskio.c
  * @brief   SD Disk I/O driver
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
  ******************************************************************************
  */
/* USER CODE END Header */

[#-- Moved here (as the user section prevents from refreshing the comments). --]
[#if use_rtos = 1]
/* Note: code generation based on sd_diskio_dma_rtos_template.c for L5 as FreeRTOS is enabled. */
[#else]
/* Note: code generation based on sd_diskio_dma_template.c for L5 as "Use dma template" is enabled. */
[/#if]

/* Includes ------------------------------------------------------------------*/
#include "ff_gen_drv.h"
#include "sd_diskio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#if defined(SDMMC_DATATIMEOUT)
#define SD_TIMEOUT SDMMC_DATATIMEOUT
#elif defined(SD_DATATIMEOUT)
#define SD_TIMEOUT SD_DATATIMEOUT
#else
#define SD_TIMEOUT 30 * 1000
#endif

#define SD_DEFAULT_BLOCK_SIZE 512
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* Disk status */
static volatile DSTATUS Stat = STA_NOINIT;
static volatile  UINT  WriteStatus = 0, ReadStatus = 0;
/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
static DSTATUS SD_CheckStatus(BYTE lun);
DSTATUS SD_initialize (BYTE);
DSTATUS SD_status (BYTE);
DRESULT SD_read (BYTE, BYTE*, DWORD, UINT);
#if _USE_WRITE == 1
  DRESULT SD_write (BYTE, const BYTE*, DWORD, UINT);
#endif /* _USE_WRITE == 1 */
#if _USE_IOCTL == 1
  DRESULT SD_ioctl (BYTE, BYTE, void*);
#endif  /* _USE_IOCTL == 1 */

/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

const Diskio_drvTypeDef  SD_Driver =
{
  SD_initialize,
  SD_status,
  SD_read,
#if  _USE_WRITE == 1
  SD_write,
#endif /* _USE_WRITE == 1 */

#if  _USE_IOCTL == 1
  SD_ioctl,
#endif /* _USE_IOCTL == 1 */
};

/* Private functions ---------------------------------------------------------*/
static DSTATUS SD_CheckStatus(BYTE lun)
{
  Stat = STA_NOINIT;
  if(BSP_SD_GetCardState(0) == BSP_ERROR_NONE)
  {
    Stat &= ~STA_NOINIT;
  }

  return Stat;
}

/**
  * @brief  Initializes a Drive
  * @param  lun : not used
  * @retval DSTATUS: Operation status
  */
DSTATUS SD_initialize(BYTE lun)
{
  /* USER CODE BEGIN SDinitialize */
  Stat = STA_NOINIT;
#if !defined(DISABLE_SD_INIT)
  if(BSP_SD_Init(0) == BSP_ERROR_NONE)
  {
    Stat = SD_CheckStatus(lun);
  }

#else
  Stat = SD_CheckStatus(lun);
#endif
  return Stat;
  /* USER CODE END SDinitialize */
}

/**
  * @brief  Gets Disk Status
  * @param  lun : not used
  * @retval DSTATUS: Operation status
  */
DSTATUS SD_status(BYTE lun)
{
  return SD_CheckStatus(lun);
}

/**
  * @brief  Reads Sector(s)
  * @param  lun : not used
  * @param  *buff: Data buffer to store read data
  * @param  sector: Sector address (LBA)
  * @param  count: Number of sectors to read (1..128)
  * @retval DRESULT: Operation result
  */
DRESULT SD_read(BYTE lun, BYTE *buff, DWORD sector, UINT count)
{
  DRESULT res = RES_ERROR;
  ReadStatus = 0;
  uint32_t timeout;
  if(BSP_SD_ReadBlocks_DMA(0, (uint32_t*)buff,
                       (uint32_t) (sector),
                       count) == BSP_ERROR_NONE)
  {
    /* Wait for the Rading process is completed or a timeout occurs */
    timeout = HAL_GetTick();
    while((ReadStatus == 0) && ((HAL_GetTick() - timeout) < SD_TIMEOUT))
    {
    }
    /* in case of a timeout return error */
    if (ReadStatus == 0)
    {
      res = RES_ERROR;
    }
    else
    {
      ReadStatus = 0;
      timeout = HAL_GetTick();

      while((HAL_GetTick() - timeout) < SD_TIMEOUT)
      {
        if (BSP_SD_GetCardState(0) == SD_TRANSFER_OK)
        {
          res = RES_OK;
           break;
        }
      }
    }
  }
  return res;
}

/**
  * @brief  Writes Sector(s)
  * @param  lun : not used
  * @param  *buff: Data to be written
  * @param  sector: Sector address (LBA)
  * @param  count: Number of sectors to write (1..128)
  * @retval DRESULT: Operation result
  */
#if _USE_WRITE == 1
DRESULT SD_write(BYTE lun, const BYTE *buff, DWORD sector, UINT count)
{
  DRESULT res = RES_ERROR;
  WriteStatus = 0;
  uint32_t timeout = HAL_GetTick();
  if(BSP_SD_WriteBlocks_DMA(0, (uint32_t*)buff,
                        (uint32_t)(sector),
                        count) == BSP_ERROR_NONE)
  {
    /* Wait for the Rading process is completed or a timeout occurs */
    while((WriteStatus == 0) && ((HAL_GetTick() - timeout) < SD_TIMEOUT))
    {
    }
    /* in case of a timeout return error */
    if (WriteStatus == 0)
    {
      res = RES_ERROR;
    }
    else
    {
      WriteStatus = 0;
      timeout = HAL_GetTick();

      while((HAL_GetTick() - timeout) < SD_TIMEOUT)
      {
        if (BSP_SD_GetCardState(0) == SD_TRANSFER_OK)
        {
          res = RES_OK;
          break;
        }
      }
    }
  }

  return res;

}
#endif /* _USE_WRITE == 1 */

/**
  * @brief  I/O control operation
  * @param  lun : not used
  * @param  cmd: Control code
  * @param  *buff: Buffer to send/receive control data
  * @retval DRESULT: Operation result
  */
#if _USE_IOCTL == 1
DRESULT SD_ioctl(BYTE lun, BYTE cmd, void *buff)
{
  DRESULT res = RES_ERROR;
  SD_CardInfo_t CardInfo;

  if (Stat & STA_NOINIT) return RES_NOTRDY;

  switch (cmd)
  {
  /* Make sure that no pending write process */
  case CTRL_SYNC :
    res = RES_OK;
    break;

  /* Get number of sectors on the disk (DWORD) */
  case GET_SECTOR_COUNT :
    BSP_SD_GetCardInfo(0, &CardInfo);
    *(DWORD*)buff = CardInfo.LogBlockNbr;
    res = RES_OK;
    break;

  /* Get R/W sector size (WORD) */
  case GET_SECTOR_SIZE :
    BSP_SD_GetCardInfo(0, &CardInfo);
    *(WORD*)buff = CardInfo.LogBlockSize;
    res = RES_OK;
    break;

  /* Get erase block size in unit of sector (DWORD) */
  case GET_BLOCK_SIZE :
    BSP_SD_GetCardInfo(0, &CardInfo);
    *(DWORD*)buff = CardInfo.LogBlockSize / SD_DEFAULT_BLOCK_SIZE;
	res = RES_OK;
    break;

  default:
    res = RES_PARERR;
  }

  return res;
}

/**
  * @brief Tx Transfer completed callbacks
  * @param hsd: SD handle
  * @retval None
  */
void BSP_SD_WriteCpltCallback(uint32_t Instance)
{
  WriteStatus = 1;
}

/**
  * @brief Rx Transfer completed callbacks
  * @param hsd: SD handle
  * @retval None
  */
void BSP_SD_ReadCpltCallback(uint32_t Instance)
{
  ReadStatus = 1;
}

#endif /* _USE_IOCTL == 1 */

/* USER CODE BEGIN lastSection */ 
/* can be used to modify / undefine previous code or add new code */
/* USER CODE END lastSection */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

