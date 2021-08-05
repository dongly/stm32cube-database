[#ftl]
[#compress]

[#----------------------------------------------------]
[#-- "dts-v1" element printer.
 --]
[#----------------------------------------------------]

[#--collect US names--]
[#assign global_userSectionsNamesList = []]

[#--manage tabulations level--]
[#function dts_get_tabs   pDtLevel ]

	[#local TABN = ""]
	[#local TABP = "\t"]
	[#if pDtLevel > 0]
		[#list 1..pDtLevel as idx ]
			[#local TABN = TABN + "\t"]
			[#local TABP = TABP + "\t"]
		[/#list]
	[/#if]

[#return {"TABN":TABN, "TABP":TABP}]
[/#function]


[#--Print single dts-v1 elmts list.
pElmt is viewed as of DTDtsElmtDM type.
pElmtClassPrintLevel: the printing level
NB: in this printing mode, "areUserSectionsAllowed" attribute is not considered right now. A US is generated only if a US element is provided.
--]
[#macro DTDtsElmtDMsList_print  pElmtsList pElmtClassPrintLevel pDtLevel pConfigsList]
[#local module = "DTDtsElmtDMsList_print"]
[#compress]

[/#compress]
	[#local elmtIdx = 0]
	[#list pElmtsList as elmt]
		[@DTDtsElmtDM_print pElmt=elmt pElmtClassPrintLevel=pElmtClassPrintLevel pDtLevel=pDtLevel pElmtIdx=elmtIdx pConfigsList=pConfigsList/]
		[#local elmtIdx = elmtIdx+1]
	[/#list]
[#-- macro end --]
[/#macro]


[#--Print single dts-v1 single elmt.
pElmt is viewed as of DTDtsElmtDM type.--]
[#--FIX: use coding rules for local var (cf include)--]
[#macro DTDtsElmtDM_print  pElmt pElmtClassPrintLevel pDtLevel pElmtIdx pConfigsList]
[#local module = "DTDtsElmtDM_print"]
[#compress]

	[#--internal configs--]
	[#local internalConfigsList = pConfigsList]

	[#--get tabulations level--]
	[#local printerTAG = ""]
	[#if pElmt.txtPrinterTag?? && pElmt.txtPrinterTag?has_content]
		[#local printerTAG = pElmt.txtPrinterTag]
		[#local dtsTAB =  printerTAG + dts_get_tabs(pDtLevel).TABN]
	[#else]
		[#local dtsTAB =  dts_get_tabs(pDtLevel).TABN]
	[/#if]

	[#--Check DTBindingElmt level --]
	[#------------------------------]
	[#local printAllowed = true]

		[#--mandatory attributes--]
	[#if pElmt.typeName?? && pElmt.typeName?has_content]
		[#local typeName = pElmt.typeName]
	[#else]
		[@mlog  logMod=module logType="ERR" logMsg="Undefined typeName" varsMap={"pElmt.typeName":pElmt.typeName!} /]
		[#local typeName = ""]
		[#local printAllowed = false]
	[/#if]

	[#--optional attributes--]
	[#local name = pElmt.name!]
	[#local parent = pElmt.parent!]

	[#--FIX: check other attributes--]


	[#--Check pElmt--]
	[#--------------------]
		[#--mandatory attributes--]
		[#--FIX: TBD --]

		[#--optional attributes--]
		[#-- FIX: TBD --]

[/#compress]
	[#-- Process all elmts in the list order --]
	[#if printAllowed]
		[#local elmtsList = pElmt.elmtsList!]	[#-- "!" means optional --]

		[#-- Begin of current elmt --]
		[#local inspectAndPrint = false] [#-- Forbid inspection of subElmts in case of error --]
		[#-- FIX: to see if "inspectAndPrint" can not be removed --]
		[#switch typeName]
			[#case "Node"]
				[#--Mandatory attributes--]
				[#local isNodeOverloading = pElmt.isNodeOverloading]
				[#--Optional attributes--]
				[#local label = pElmt.nodeLabel!]
				[#local nodeUnitAddress = pElmt.nodeUnitAddress!]
[#t]
				[#--Print--]
				[#local inspectAndPrint = true]

				[#if isNodeOverloading]
${dtsTAB}&${name}{
				[#else]
${dtsTAB}[#if label?has_content]${label}:[/#if]${name}[#if nodeUnitAddress?has_content]@${nodeUnitAddress}[/#if]{
				[/#if]
[#t]
			[#break]
[#t]
			[#case "Property"]
				[#--FIX: prop def can be also from FTL Api => increase check level (exple: check any param of the Api above)--]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#local format = pElmt.valueFormat!]
[#t]
				[#--Print--]
				[#local propStorageSize = ""]
				[#if format?has_content]
					[#local propStorageSize = "/bits/ " + format + " "]
				[/#if]
				[#if name?has_content]
					[#local inspectAndPrint = true]
					[#if elmtsList?has_content]
						[#if (elmtsList?size>1) && internalConfigsList?seq_contains("MX_PRINT_PROPVALUEITEMSWITHEOL") && (name!="compatible")]
							[#local internalConfigsList = internalConfigsList + ["cfg_propValueItemsWithEol"]]
						[/#if]
${dtsTAB}${name} = ${propStorageSize}[#t]
					[#else]
${dtsTAB}${name}[#t]
					[/#if]
				[#else]
					[#--FIX: review msg printed--]
					[@mlog  logMod=module logType="ERR" logMsg="Property: undefined property name" varsMap={"typeName":typeName!, "name":name!} /]
				[/#if]
			[#break]
[#t]
			[#case "ValueItem"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#local format = pElmt.valueFormat!]
[#t]
				[#--Print--]
				[#if elmtsList?has_content]
					[#local inspectAndPrint = true]
					[#--FIX: improve err mngt: Today won't compile. Strategy is to always compile and add corrections in US--]
						[#local propValueItemSeparator = ""]
					[#if pElmtIdx > 0]
						[#local propValueItemSeparator = ", "]
						[#if internalConfigsList?seq_contains("cfg_propValueItemsWithEol")][#--priority--]
							[#local propValueItemSeparator = ",\r\n" + dtsTAB + "\t"]
						[#elseif pElmt.isEolBefore?? && pElmt.isEolBefore]
							[#local propValueItemSeparator = ",\r\n" + dtsTAB + "\t"]
						[/#if]
					[/#if]
					[#if (format=="string")]
						[#local propValueItemStart = "\""]
						[#local propValueItemEnd = "\""]
					[#elseif (format=="integer")]
						[#local propValueItemStart = "<"]
						[#local propValueItemEnd = ">"]
					[#elseif (!format?has_content)]
						[#local propValueItemStart = ""]
						[#local propValueItemEnd = ""]
					[#else]
						[#local propValueItemSeparator = " "]
						[#local propValueItemStart = "/*"]
						[#local propValueItemEnd = "*/"]
						[@mlog  logMod=module logType="ERR" logMsg="unknown PropValueItem format" varsMap={"typeName":typeName!, "name":name!, "format":format!} /]
					[/#if]
${propValueItemSeparator}${propValueItemStart}[#t]
				[#else]
					[@mlog  logMod=module logType="ERR" logMsg="ValueItem w no content" varsMap={"typeName":typeName!, "name":name!} /]
				[/#if]
			[#break]
[#t]
			[#case "ArrayItem"]
				[#--Mandatory attributes--]
				[#local value = pElmt.value]
				[#--Optional attributes--]
				[#local valueType = pElmt.valueType!]
[#t]
				[#--Print--]
				[#if value?has_content]
[#local propArrayItemSeparator = ""]
					[#if pElmtIdx > 0]
[#local propArrayItemSeparator = " "]
					[/#if]
					[#local inspectAndPrint = true]
					[#if (valueType=="dec")]
						[#local possibleValueStart = ""]
					[#elseif (valueType=="hex")]
						[#local possibleValueStart = "0x"]
					[#elseif (valueType=="phandle")]
						[#local possibleValueStart = "&"]
					[#elseif (!valueType?has_content)]
						[#local possibleValueStart = ""]
					[#else]
						[#local propArrayItemSeparator = " "]
						[#local possibleValueStart = ""]
					[#--FIX: improve err mngt: Today won't compile. Strategy is to always compile and add corrections is US--]
						[@mlog  logMod=module logType="ERR" logMsg="unknown ArrayItem type" varsMap={"typeName":typeName!, "name":name!, "valueType":valueType!} /]
					[/#if]
${propArrayItemSeparator}${possibleValueStart}${value}[#t]
				[#else]
					[@mlog  logMod=module logType="ERR" logMsg="ArrayItem w no Value" varsMap={"typeName":typeName!, "name":name!} /]
				[/#if]
			[#break]
[#t]
			[#case "Include"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#--Print--]
				[#if name?contains(".ftl")][#--special case--]
					[#if name?contains("/")]
						[#--FIX: err mngt--]
						[#local strsList = name?split("/")]
						[#local fileName = strsList[0]]
						[#local macroName = strsList[1]]
						[#include global_includeFtlPath +  fileName]
						[@.vars[macroName] pElmt=pElmt pDtLevel=pDtLevel /]
					[#else]
						[#include global_includeFtlPath +  name]
					[/#if]
				[#else ][#--dts-v1 include--]
					[#local formatOn = ""]
					[#local formatOff = ""]
					[#local format = pElmt.valueFormat!]
					[#if (format=="\"")]
						[#local formatOn = "\""]
						[#local formatOff = "\""]
					[#elseif (format=="<") || (format==">")]
						[#local formatOn = "<"]
						[#local formatOff = ">"]
					[/#if]
					[#if (formatOn?has_content) && (formatOff?has_content)]
${printerTAG}#include ${formatOn}${name}${formatOff}
					[#else]
						[@mlog  logMod=module logType="ERR" logMsg="Unknown dts-v1 include format" varsMap={"format":format!, "name":name!} /]
					[/#if]
				[/#if]
			[#break]
[#t]
			[#case "UserSection"]
				[#--Mandatory attributes--]
				[#local usName = name]
				[#--Optional attributes--]
				[#--Print--]
[#--UserSection name generation: DO NOT CHANGE !!!--]
				[#if !usName?has_content]
					[#local usNameRes = DTDtsElmtDM_generate_UserSectionName(parent, 0)]
					[#if !usNameRes.errors?has_content]
						[#local usName = usNameRes.name]
					[/#if]
				[/#if]
[#--UserSection name generation !!!--]

				[#if !usName?has_content]
${dtsTAB}/*ERR : Cannot generate User-Section (no name).*/
				[#elseif global_userSectionsNamesList?seq_contains(usName)]
${dtsTAB}/*ERR : Cannot generate User-Section (existing name: ${usName}).*/
				[#else]
					[#assign global_userSectionsNamesList = global_userSectionsNamesList + [usName]]
					[#local inspectAndPrint = true]
${dtsTAB}/* USER CODE BEGIN ${usName} */
				[/#if]
			[#break]
[#t]
			[#case "CppComment"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#if pElmt.value?? &&  pElmt.value?has_content]
					[#local value = pElmt.value]
				[#else]
					[#local value = ""]
				[/#if]
${dtsTAB}// ${value}
				[#--Print--]
			[#break]
[#t]
			[#case "Directive"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#if pElmt.value?? &&  pElmt.value?has_content]
					[#if !pElmt.isNodeOverloading]
${dtsTAB}/${name}/ ${pElmt.value}[#t]
					[#else]
${dtsTAB}/${name}/ &${pElmt.value}[#t]
					[/#if]
				[#else]
${dtsTAB}/${name}/[#t]
				[/#if]
				[#--Print--]
				[#local inspectAndPrint = true]
			[#break]
[#t]
			[#case "CPreProcConditionsContainer"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#--Print--]

[#nt][#t]
				[#local inspectAndPrint = true]
			[#break]
[#t]
			[#case "CPreProcCondition"]
				[#--Mandatory attributes--]
				[#--Optional attributes--]
				[#if name?? && name?has_content && pElmt.value??]
					[#local value = pElmt.value]
					[#local dtsTABCpp = dtsTAB]
					[#if dtsTABCpp?has_content]
						[#local dtsTABCpp = dtsTABCpp?substring(1)][#--cf inclusion into container--]
					[/#if]
					[#if value?has_content]
${printerTAG}#${name} ${value}
					[#else]
${printerTAG}#${name}
					[/#if]
					[#--Print--]
					[#local inspectAndPrint = true]
				[#else]
					[@mlog  logMod=module logType="ERR" logMsg="C Pre Proc condition w no name or value" varsMap={"typeName":typeName!, "name":name!, "value":value!} /]
				[/#if]
			[#break]
[#t]
			[#default]
				[@mlog  logMod=module logType="ERR" logMsg="unknown element type" varsMap={"typeName":typeName!, "name":name!} /]
		[/#switch]
[#t]
[#t]
		[#-- Inspect subElmts --]
		[#if inspectAndPrint==true]
[#t]
			[#-- FIX: see perf. Do not check on each elmt--]
			[#local ordering = false]
			[#if (typeName=="Node")]
				[#local ordering = true]
			[/#if]
			[#if (typeName!="UserSection") && (typeName!="CPreProcConditionsContainer") && (typeName!="CPreProcCondition")]
				[#local dtLevel = pDtLevel+1]
			[#else]
				[#local dtLevel = pDtLevel]
			[/#if]
			[#if (pElmtClassPrintLevel=="DTBindedDtsElmtDM")]
				[#-- DTBindedDtsElmtDM elmt type printing--]
				[@DTBindedDtsElmtDMsList_print  pParentElmt=pElmt pElmtsList=elmtsList pDtLevel=dtLevel pOrdering=ordering/]
			[#elseif  (pElmtClassPrintLevel=="DTDtsElmtDM")]
				[#-- DTDtsElmtDM elmt type printing--]
				[@DTDtsElmtDMsList_print pElmtsList=elmtsList pElmtClassPrintLevel=pElmtClassPrintLevel pDtLevel=dtLevel pConfigsList=internalConfigsList/]
			[#else]
				[@mlog  logMod=module logType="ERR" logMsg="unknown pElmtClassPrintLevel" varsMap={"pElmtClassPrintLevel":pElmtClassPrintLevel!} /]
			[/#if]
[#t]
			[#-- End of current elmt --]
			[#switch typeName]
				[#case "Node"]
${dtsTAB}};
				[#break]
[#t]
				[#case "Property"]
;
				[#break]
[#t]
				[#case "ValueItem"]
${propValueItemEnd}[#t]
				[#break]
[#t]
				[#case "ArrayItem"]
[#nt][#t]
				[#break]
[#t]
				[#case "PossibleValue"]
				[#break]
[#t]
				[#case "Include"]
				[#break]
[#t]
				[#case "UserSection"]
					[#if usName?has_content]
${dtsTAB}/* USER CODE END ${usName} */
					[/#if]
				[#break]
[#t]
				[#case "CppComment"]
				[#break]
[#t]
				[#case "Directive"]
;
				[#break]
[#t]
			[#case "CPreProcConditionsContainer"]
#endif
			[#break]
[#t]
			[#case "CPreProcCondition"]
			[#break]
[#t]
				[#default]
					[@mlog  logMod=module logType="ERR" logMsg="unknown element type" varsMap={"typeName":typeName!, "name":name!} /]
			[/#switch]
		[/#if]
[#t]
	[#else]
		[@mlog  logMod=module logType="ERR" logMsg="DTBindedDtsElmtDM parameters error" varsMap={"typeName":typeName!, "name":name!} /]
	[/#if]
[#compress]

[#-- macro end --]
[/#compress]
[/#macro]


[#--------------------------------------------------------------------------------------------------------------------------------]
[#--UserSection name generation--]
[#--------------------------------------------------------------------------------------------------------------------------------]

[#--UserSection name generation: DO NOT CHANGE !!!--]

[#--Generate a US name: "pParentElmt" is the elmt (a Node or an US) where the US stands.
pParentElmt belongs to DTDtsElmtDM type.--]
[#function DTDtsElmtDM_generate_UserSectionName  pParentElmt pLevel]
[#local module = "DTDtsElmtDM_generate_UserSectionName"]
[#local traces =  ftrace("", "module="+module+"\n") ]
[#local errors = ""]

	[#if pLevel < 30]
		[#local parentElmt = pParentElmt]
		[#if parentElmt?has_content]
			[#if parentElmt.typeName!="UserSection"]
				[#--Mandatory attributes--]
				[#local isNodeOverloading = parentElmt.isNodeOverloading]
				[#local name = parentElmt.name]
				[#if (name=="/")]
					[#local name = "root"][#--"root" US--]
				[/#if]
				[#--Optional attributes--]
				[#local label = parentElmt.nodeLabel!]
				[#local unitAddress = parentElmt.nodeUnitAddress!]
			[#else]
				[#--US--]
				[#local label = ""]
				[#local isNodeOverloading = false]
				[#local name = ""]
				[#local unitAddress = ""]
			[/#if]

			[#if label?has_content]
				[#--use label (preferred)--]
				[#local usName = label]
			[#elseif isNodeOverloading]
				[#--if no label, use parent elmt ref if it is an overload--]
				[#local usName = name]
			[#else]
				[#--name = parentUSName_name-unitAddress--]
				[#local usName = name]
				[#if unitAddress?has_content]
					[#local usName = usName + "-" + unitAddress]
				[/#if]

				[#if parentElmt.parent??]
					[#local usNameRes = DTDtsElmtDM_generate_UserSectionName(parentElmt.parent, (pLevel+1))]
					[#local errors = usNameRes.errors]
					[#if !usNameRes.errors?has_content]
						[#if parentElmt.typeName!="UserSection"]
							[#--never use "root" id excepted for root node--]
							[#if  usNameRes.name!="root"]
								[#local usName = usNameRes.name + "_" + usName]
							[/#if]
						[#else]
							[#--skip US--]
							[#local usName = usNameRes.name]
						[/#if]
					[/#if]
				[#--else: parent.parent is .dts level => stop algorithm--]
				[/#if]
			[/#if]
		[#else]
			[#local errors = "empty parent"]
		[/#if]
	[#else]
		[#--control recursivity--]
		[#local errors = "too high level"]
	[/#if]

	[#return {"errors":errors!, "name":usName!, "traces":traces!} ]
[/#function]

[#--UserSection name generation--]

[#--------------------------------------------------------------------------------------------------------------------------------]
[#--------------------------------------------------------------------------------------------------------------------------------]
[/#compress]
