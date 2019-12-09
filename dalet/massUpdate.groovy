import java.text.SimpleDateFormat 
def obj_asset, obj_enum, obj_value, obj_dst, out_date, history_value
TimeZone.setDefault(TimeZone.getTimeZone("GMT+3"))
dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss") 
out_date = dateFormat.format(new Date()) as String

def pkvs_PG = 879
def pkvs_PG_History = 2030
def pkvs_Dalet_Edit_History = 1571

// Get Author
def inputAuthor = [[Get Order Author 2.assetInfoValue]]
// Get PG from request
def pg_value = [[Get PG.assetInfoValue]]
// Get List of titles from request
def titleIds = [[Get Order Titles 2.assetInfoValue]]
def titleIdsArray = titleIds.split(',')
history_value = out_date + " Responsoble for PG: " + pg_value + " - " + inputAuthor

for (item in titleIdsArray) {
	// Get Object of asset by ID
	obj_asset = item.toInteger()
	// Set enumerator
	obj_enum = com.dalet.webservice.services.metadataservice.definition.ObjectTypeEnum.ASSET
	// Prepare data types
	obj_pkvs_PG = new com.dalet.webservice.services.metadataservice.definition.TextAssetInfo()
	obj_pkvs_PG_History = new com.dalet.webservice.services.metadataservice.definition.StringAssetInfoMulti()
	obj_pkvs_Dalet_Edit_History = new com.dalet.webservice.services.metadataservice.definition.StringAssetInfoMulti()
	// Set id's of data fields
	obj_pkvs_PG.setDataFieldId(pkvs_PG)
	obj_pkvs_PG_History.setDataFieldId(pkvs_PG_History)
	obj_pkvs_Dalet_Edit_History.setDataFieldId(pkvs_Dalet_Edit_History)
	// Set values
	obj_pkvs_PG.setValue(pg_value)
	obj_pkvs_PG_History.setValues([pg_value + " | " + out_date_PG + " | " + inputAuthor])
	obj_pkvs_Dalet_Edit_History.setValues([history_value])
	// Commit values to API
	daletAPI.MetadataService().addMetadataToObject(obj_asset, obj_enum, [obj_pkvs_PG])
	daletAPI.MetadataService().appendValueToObjects([obj_asset], obj_enum, obj_pkvs_PG_History)
	daletAPI.MetadataService().appendValueToObjects([obj_asset], obj_enum, obj_pkvs_Dalet_Edit_History)
}

context.setVariable(execution, 'output', history_value)