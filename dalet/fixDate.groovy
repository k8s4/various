import groovy.time.TimeCategory
def obj_asset, obj_enum, obj, obj_meta, obj_tdassetinfo, obj_dst
def output = 0
// pkvs_PKAirDate ; 1976
def metafieldid = 1976
// Get Title ID
long titleid = ([[pkvs_PKAirDate Field Changed.titleId]]).toLong()
// Get Object of asset by ID
obj_asset = daletAPI.AssetService().getAsset(titleid)
// Type ASSET
obj_enum = com.dalet.webservice.services.metadataservice.definition.ObjectTypeEnum.ASSET
// Get object metadata by ID list
obj = daletAPI.MetadataService().getObjectMetadataByFields(obj_asset.id, obj_enum, [metafieldid])
if (!obj.isEmpty()) {
	obj_meta = obj.getFirst()
	// Clear time to 00:00:00
	//obj_meta.value.clearTime()
	// Diag
	// output = obj_meta.value.get(Calendar.HOUR_OF_DAY)
	// If 21 hours then add 3 hour
	if (obj_meta.value.get(Calendar.HOUR_OF_DAY) == 21) {
		obj_meta.value.add(Calendar.HOUR_OF_DAY, 3)
		// Create TimeDataAssetInfo object
		obj_tdassetinfo = new com.dalet.webservice.services.metadataservice.definition.TimeDateAssetInfo()
		//obj_tdassetinfo.setDataFieldTagName("pkvs_PKAirDate_DT")
		//obj_tdassetinfo.setDataFieldName("pkvs_PKAirDate_DT")
		// Set id of date-time field
		obj_tdassetinfo.setDataFieldId(metafieldid)
		// Set modified date-time
		obj_tdassetinfo.setValue(obj_meta.value)
		// Add metadata to asset
		obj_dst = daletAPI.MetadataService().addMetadataToObject(obj_asset.id, obj_enum, [obj_tdassetinfo])
		output = 1
	}
} 
context.setVariable(execution, 'output', output)