[#ftl]
<?xml version="1.0" encoding="UTF-8"?>
<Project>
<ProjectName>${projectName}</ProjectName>
<CMSIS>${CMSISPath}</CMSIS>
[#if ide=="EWARM" || ide=="MDK-ARM"]
	<HAL_Driver>${HAL_Driver}</HAL_Driver>
[/#if]


 [#-- list of toolchains to be generated: EWARM,MDK-ARM,TrueSTUDIO,RIDE: This tag can contain one or more than one toolchain: EWARM,MDK-ARM,TrueSTUDIO,RIDE --]
<Toolchain>${ide}</Toolchain>
[#if ide=="MDK-ARM"]
	<Toolversion>${Toolversion}</Toolversion>
[/#if]
<Version>${version}</Version>

<filestoremove>
	<file>
		[#list SourceFilesToRemove as SourceFile]
	   		<name>${SourceFile}</name>
        [/#list]
	</file>
</filestoremove>

<inctoremove>
	<Aincludes>
	   <include></include>
    </Aincludes>
	<Cincludes>
		[#list IncludePathsToRemove as IncludePath]
	   		<include>${IncludePath}</include>
        [/#list]
    </Cincludes>
</inctoremove>


<configs>
  <config>
    <name>${Configuration}</name>				[#-- project configuration name. Ex: STM32F407_EVAL --]
    <device>${project.deviceId}</device>		 [#--  STM32 selected device. Ex: STM32F407ZE --]
    <heapSize>${HeapSize}</heapSize>
    <stackSize>${StackSize}</stackSize>
    
    [#if ide=="EWARM" || ide=="MDK-ARM"]
    	<cpuclock>${cpuclock}</cpuclock>
    [/#if]
    [#if boardName != ""]
    	<board>${boardName}</board>
    [/#if]
    [#--optional part--]
    <usedDebug>${usedDebug}</usedDebug>
    [#if usedDebug == "true"]
    	<debugprobe>${DebugMode}</debugprobe>
	[/#if]
    [#-- <optimization>${project.compilerOptimization}</optimization> --]
    <optimization></optimization>
    <icfloc>${icfloc}</icfloc>
    <Adefines>
       <define></define>
    </Adefines>
    <UsedFreeRTOS>${usedfreeRTOS}</UsedFreeRTOS>
    <Aincludes>
    	[#if usedfreeRTOS=="true"]
	   		[#if ide=="EWARM" ]
		   		<include>$PROJ_DIR$\${RelativePath}Inc</include>
	   		[#elseif ide=="MDK-ARM" ]
	   			<include>${RelativePath}Inc</include>
		    [#else]
		   		<include></include>
		    [/#if]
	    [#else]
	    	<include></include>
    	[/#if]
    </Aincludes>
	<Cdefines>
	   [#list CdefinesList as define]
       <define>${define}</define>
        [/#list]
	   [#-- <define>__weak=__attribute__((weak))</define> --]
    </Cdefines>
    [#-- End of optional part--]
	<Cincludes>
	 [#-- required includes for all generated projects --]
	 <include>${RelativePath}Inc</include>
     [#-- <include>${CMSISPath}\Device\ST\${family}\Include</include>
     <include>${CMSISPath}\Include</include> --]
	   [#list halIncludePaths as halIncludePath]
	   <include>${halIncludePath}</include>
        [/#list]
    </Cincludes>
    [#--
    [#if ide=="SW4STM32"]
    <sourceEntries>
    	<sourceEntry>
    		<name>${inc}</name>
    	</sourceEntry>
    	<sourceEntry>
    		<name>${src}</name>
    	</sourceEntry>
    	<sourceEntry>
    		<name>${HALDriver}</name>
    	</sourceEntry>
    </sourceEntries>
    [/#if]
    --]
  </config>
</configs>
[#-- project groups and files --]
[#--if ide != "SW4STM32"] --]
	[#if atLeastOneMiddlewareIsUsed]
	  <group>
	  <name>Middlewares</name>
		 [#list groups as group]
		 	<group>
		 		<name>${group.name!''}</name>
		 		[#if group.sourceFilesNameList??]
			 		[#list group.sourceFilesNameList as filesName]
						<file>
							<name>${filesName!''}</name>
						</file>
			        [/#list]
			    [/#if]
		    </group>
		 [/#list]
	  </group> 
	 [/#if]
	 
	   <group>
	    <name>Drivers</name> 
		   <group>
		 		<name>${HALGroup.name!''}</name>
		 		[#if HALGroup.sourceFilesNameList??]
			 		[#list HALGroup.sourceFilesNameList as filesName]
						<file>
							<name>${filesName!''}</name>
						</file>
			        [/#list]
			     [/#if]
		    </group>
	  </group>   
	  
	  <group>
	  <name>Application</name>
	    <group>
	      <name>User</name>  
	        [#list mxSourceFilesNameList as mxCFiles]
	        <file>
	         <name>${mxCFiles}</name>
	        </file>
	       [/#list]
	    </group>
	  </group>
 [#-- [/#if] --]
 [#-- 
  <group>
    <name>Drivers</name> 
	    <group>
	      <name>STM32F4xx_HAL_Driver</name>
	        [#list halSourceFilesNameList as halCFiles]
	       <file>
	        <name>${halCFiles}</name>
	      </file>
	        [/#list]
	    </group>
  </group>   

	 <group>
	      <name>Middelwares</name>  
		  <group>  
		   	<name>FreeRTOS</name>
		    <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/portable/MemMang/heap_4.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/portable/IAR/ARM_CM4F/port.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/portable/IAR/ARM_CM4F/portasm.s</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/croutine.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/list.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/queue.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/tasks.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/timers.c</name>
	      </file>
	       <file>
	        <name>${RelativePath}Middlewares/Third_Party/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c</name>
	      </file>
	    </group>
	    <group>  
	   		 <name>LwIP</name>
	    </group>
	 </group>
 --]	   
</Project>