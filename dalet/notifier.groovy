import com.dalet.webservice.services.errors.ResourceDoesNotExist
import com.dalet.webservice.services.errors.ResourcePreconditionViolation
import org.activiti.engine.delegate.BpmnError
import org.apache.log4j.BasicConfigurator
import org.slf4j.LoggerFactory

// Global vars and objs
def varCurrentDate, varGlobalIF
public class gVars { 
	public static long titleid 
	public static obj_asset		
	public static obj_allstatuses
	public static status_id
	public static obj_enum
	public static obj_log	
	public static var_format_date

	public static varName
	public static varPkvsTitle
	public static varTitlePrimaryCategoryId
	public static varTitlePrimaryCategoryName
	public static varPkvsMaterialType
	public static varTitleStatus
}

// Base and OTK vars
def varPkvsAirApprove, varName, varPkvsMaterialType, varTitleComment1, varStartOfMaterial, varPkvsTitle, varTitlePrimaryCategoryId, varTitlePrimaryCategoryName, varTitleDuration, varPkvsVideoEvaluation, varPkvsVideoDefect, varPkvsAudioEvaluation, varPkvsAudioDefect, varPkvsOTKDefinitionGrade, varPkvsOTKVideoGrade, varPkvsOTKAudioGrade, varPkvsOTKTitlesGrade, varPkvsOTKAuthor
// Anons vars
def varPkvsUID16chars, varPkvsAnonsAIRDate, varPkvsAnonsAIREndDate, varPkvsAnonsComments, varPkvsWeekDay, varPkvsChannelsFullList
// Create obj logger
gVars.obj_log = LoggerFactory.getLogger('GetMetaDataScript')
// Get All Global Statuses
gVars.obj_allstatuses = daletAPI.ConfigurationService().getAllStatuses()
// Set Format of Date and Time
gVars.var_format_date = "yyyy-MM-dd HH:mm:ss"
// Define condition fields
def list_BASE = [1, 760, 825, 877, 5000]
// Define default fields for OTK
def list_OTK = [3, 38, 106, 890, 891, 892, 893, 901, 994, 995, 996, 997, 935]
def list_ANONS = [939, 942, 961, 963, 1014, 1015]
def list_CLIP = [901]


//###############################################################
//#### Functions Block
//// Main Get Method
def GetMeta(id) {
// .value, .value.frames, .value.rate, .value.period, .values
	obj = daletAPI.MetadataService().getObjectMetadataByFields(gVars.obj_asset.id, gVars.obj_enum, [id])
	if (!obj.isEmpty()) {
		return obj.getFirst()
	} else {
		return "N/A"
	}
}
//// Simple get date
def CurrentDate(format = gVars.var_format_date) {
    def date = new Date()
    return date.format(format) 
}
//// Mode 0 - Translate frames to String TimeCode, offset is offset in seconds, only for mode 0
//// Mode 1 - Translate Peroiod to String TimeCode, rate is milleseconds by frame (actually 40ms)
def sometotc(def modefunc, varnumber, varrate, offset = 10800) {    
	def frames, framesmil, framesout, seconds, todate
	if (modefunc == 0) {
		frames = varnumber % varrate
		seconds = (varnumber - frames ) / varrate
		todate = (seconds.toInteger() - offset) * 1000
    } else if (modefunc == 1) {
		framesmil = varnumber % 1000
		seconds = varnumber - framesmil  
		frames = framesmil / varrate
		todate = seconds.toInteger() - offset * 1000
	}
	def duration = new Date(todate)
	if (frames == 0){ framesout = "00" } else if (frames <= 9) { framesout = "0" + frames } else { framesout = frames }
	return duration.format("HH:mm:ss") + ":" + framesout
}

def MetaDB(id_list) {
	def out
	//// Condition Iterator + case
	for( i = 0; i < id_list.size(); i++ ) {
		out = ""
		// Get MetaData Field by [i] iterator
		//def iterator = (GetMeta(id_list[i]).value).toString()
		switch (id_list[i]) {
			case 1:
				gVars.varName = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varName', gVars.varName)
				break
			case 3:
				// Get and convert duration (format *sMMM, where *s - seconds, MMM - milleseconds) to timecode HH:mm:ss:ff
				try {
					context.setVariable(execution, 'varTitleDuration', sometotc(1, (GetMeta(id_list[i]).value.period).toInteger(), 40).toString())
				} catch (all) {
					gVars.obj_log.error("field 3 in period problem.")
					throw new BpmnError("field 3 in period problem.")
				}
				break
			case 38:
				varTitleComment1 = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varTitleComment1', varTitleComment1)
				break
			case 106:
				// Get and convert strat timecode in milleseconds to timecode HH:mm:ss:ff
				try {
					context.setVariable(execution, 'varStartOfMaterial', sometotc(0, GetMeta(id_list[i]).value.timeCode.frame, GetMeta(id_list[i]).value.timeCode.rate).toString())
				} catch (all) {
					gVars.obj_log.error("field 106 in timecode problem.")
					throw new BpmnError("field 106 in timecode problem.")
				}
				break
			case 760:
				gVars.varPkvsTitle = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsTitle', gVars.varPkvsTitle)
				break
			case 825:
				gVars.varTitlePrimaryCategoryName = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varTitlePrimaryCategoryName', gVars.varTitlePrimaryCategoryName)
				break
			case 877:
				gVars.varPkvsMaterialType = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsMaterialType', gVars.varPkvsMaterialType)
				break
			case 890:
				varPkvsVideoEvaluation = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsVideoEvaluation', varPkvsVideoEvaluation)
				break
			case 891:
				varPkvsAudioEvaluation = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsAudioEvaluation', varPkvsAudioEvaluation)
				break
			case 892:
				varPkvsVideoDefect = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsVideoDefect', varPkvsVideoDefect)
				break
			case 893:
				varPkvsAudioDefect = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsAudioDefect', varPkvsAudioDefect)
				break
			case 901:
				varPkvsAirApprove = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsAirApprove', varPkvsAirApprove)
				break
			case 942:
				varPkvsAnonsComments = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsAnonsComments', varPkvsAnonsComments)
				break
			case 994:
				varPkvsOTKDefinitionGrade = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsOTKDefinitionGrade', varPkvsOTKDefinitionGrade)
				break
			case 995:
				varPkvsOTKVideoGrade = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsOTKVideoGrade', varPkvsOTKVideoGrade)
				break
			case 996:
				varPkvsOTKAudioGrade = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsOTKAudioGrade', varPkvsOTKAudioGrade)
				break
			case 997:
				varPkvsOTKTitlesGrade = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsOTKTitlesGrade', varPkvsOTKTitlesGrade)
				break
			case 935:
				varPkvsOTKAuthor = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsOTKAuthor', varPkvsOTKAuthor)
				break
			case 939:
				// Field type is Gregorian Date
				varPkvsAnonsAIRDate = (GetMeta(id_list[i]).toString() == "N/A") ? "N/A" : (GetMeta(id_list[i]).value.format(gVars.var_format_date)).toString()
				context.setVariable(execution, 'varPkvsAnonsAIRDate', varPkvsAnonsAIRDate)
				break
			case 961:
				varPkvsUID16chars = (GetMeta(id_list[i]).value).toString()
				context.setVariable(execution, 'varPkvsUID16chars', varPkvsUID16chars)
				break
			case 963:
				// Field type is Gregorian Date
				varPkvsAnonsAIREndDate = (GetMeta(id_list[i]).toString() == "N/A") ? "N/A" : (GetMeta(id_list[i]).value.format(gVars.var_format_date)).toString()
				context.setVariable(execution, 'varPkvsAnonsAIREndDate', varPkvsAnonsAIREndDate)
				break
			case 1014:
				// Field type is String Multi
				try {
					varPkvsWeekDay = (GetMeta(id_list[i]).toString() == "N/A") ? "N/A" : (GetMeta(id_list[i]).values).toString()
					context.setVariable(execution, 'varPkvsWeekDay', varPkvsWeekDay)
				} catch (all) {
					gVars.obj_log.error("field 1014 in values problem.")
					throw new BpmnError("field 1014 in values problem.")
				}
				break
			case 1015:
				// Field type is String Multi
				try {
					varPkvsChannelsFullList = (GetMeta(id_list[i]).toString() == "N/A") ? "N/A" : (GetMeta(id_list[i]).values).toString()
					context.setVariable(execution, 'varPkvsChannelsFullList', varPkvsChannelsFullList)
				} catch (all) {
					gVars.obj_log.error("field 1015 in values problem.")
					throw new BpmnError("field 1015 in values problem.")
				} 
				break
			case 5000:
				// Special access to StatusID
				try {
					gVars.status_id = gVars.obj_asset.getStatusId()
					gVars.obj_allstatuses.each {  if (it.id == gVars.status_id) { gVars.varTitleStatus = (it.name).toString() } }
				} catch (all) {
					gVars.obj_log.error("field 5000 in values problem.")
					throw new BpmnError("field 5000 in values problem.")
				} 
				break
			default:
				break
		}
	}
}

//###############################################################
//#### Main Programm
try {
// Set Title ID
	if ([[Start manually.titleID]]) {
		gVars.titleid = ([[Start manually.titleID]]).toLong()
	} else if ([[Start by Link to category.titleId]]) {
		gVars.titleid = ([[Start by Link to category.titleId]]).toLong()
	} else if ([[Start by Title status modified.titleId]]) {
		gVars.titleid = ([[Start by Title status modified.titleId]]).toLong()	
	} else {
		gVars.titleid = 0
	}
// Set Primary Category ID
	if ([[Start by Link to category.categoryId]]) {
		gVars.varTitlePrimaryCategoryId = ([[Start by Link to category.categoryId]]).toLong()
	} else if ([[Get CategoryID by Status.assetInfoValue]]) {
		gVars.varTitlePrimaryCategoryId = ([[Get CategoryID by Status.assetInfoValue]]).toLong()		
	} else if ([[Get CategoryID by Manual.assetInfoValue]]) {
		gVars.varTitlePrimaryCategoryId = ([[Get CategoryID by Manual.assetInfoValue]]).toLong()	
	} else {
		gVars.varTitlePrimaryCategoryId = 0
	}
// Get class of Asset from API2
	gVars.obj_asset = daletAPI.AssetService().getAsset(gVars.titleid)
	gVars.obj_enum = com.dalet.webservice.services.metadataservice.definition.ObjectTypeEnum.ASSET
} catch (all) {
	gVars.obj_log.error("GetAsset problem. Title with id ${gVars.titleid} not found.")
	throw new BpmnError("GetAsset problem. Title with id ${gVars.titleid} not found.")
}

// Get Condition Variables
MetaDB(list_BASE)
// Global Condition maker, for Exclusive Gateway
if (gVars.varTitleStatus == "СНЯТЬ С ЭФИРА") {
	if (gVars.varTitlePrimaryCategoryId == 971) {				// "3 ЭФИР"
		MetaDB(list_ANONS)
		varGlobalIF = "ANONS_REM_FROM_AIR"	
	}
} else if (gVars.varTitlePrimaryCategoryId == 1524) {			// "ОДОБРЕНО"
	if (gVars.varPkvsMaterialType == "Анонс") {
		MetaDB(list_OTK)
		varGlobalIF = "OK_ANONS"
	} else if (gVars.varPkvsMaterialType == "Реклама") {
		MetaDB(list_OTK)
		varGlobalIF = "OK_REKLAMA"
	} else {
		MetaDB(list_OTK)
		varGlobalIF = "OK_DEFAULT"
	}
} else if (gVars.varTitlePrimaryCategoryId == 1523) {			// "НЕ ПРИГОДНО"
	if (gVars.varPkvsMaterialType == "Анонс") {
		MetaDB(list_OTK)
		varGlobalIF = "NOTOK_ANONS"
	} else if (gVars.varPkvsMaterialType == "Реклама") {
		MetaDB(list_OTK)
		varGlobalIF = "NOTOK_REKLAMA"
	} else {
		MetaDB(list_OTK)
		varGlobalIF = "NOTOK_DEFAULT"
	}
} else if (gVars.varTitlePrimaryCategoryId == 971) {			// "3 ЭФИР"
	if (gVars.varPkvsMaterialType == "Анонс") {
		MetaDB(list_ANONS)
		varGlobalIF = "ANONS_TO_AIR"
	}
} else if (gVars.varTitlePrimaryCategoryId == 1371) {				// "КЛИПЫ"
	if (gVars.varTitleStatus == "ОДОБРЕНО") {
		MetaDB(list_CLIP)
		varGlobalIF = "RECEIVED_CLIP"
	}
}
context.setVariable(execution, 'varGlobalIF', varGlobalIF)

// Job END at Current Date Time
context.setVariable(execution, 'varCurrentDate', CurrentDate())
