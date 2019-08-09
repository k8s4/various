def obj_asset, obj_enum, obj, obj_meta, obj_tdassetinfo, obj_dst, obj_user, if_obj, countid
def output = 0
// Title Author - 2; Title Last Updated By - 8
def metafieldid = 2
// last user id 
def maxusers = 600
// Get Title ID
long titleid = ([[Start event.titleID]]).toLong()
// Get Object of asset by ID
obj_asset = daletAPI.AssetService().getAsset(titleid)
// Type ASSET
obj_enum = com.dalet.webservice.services.metadataservice.definition.ObjectTypeEnum.ASSET
// Get object metadata by ID list
obj = daletAPI.MetadataService().getObjectMetadataByFields(obj_asset.id, obj_enum, [metafieldid])
if (!obj.isEmpty()) {
    if_obj = obj.getFirst().value
// Get all users	
	for( countid = 1; countid < maxusers; countid++ ) {
		// Check and Catch unknown user ids
		try {
			obj_user = daletAPI.UserService().getUser(countid)
		} catch (ResourceDoesNotExist) {
			continue
		}
		// Finally check target user
		if (if_obj == (obj_user.lastName + " " + obj_user.firstName)) {
			output = obj_user.login
			break
		}
	}
} 
context.setVariable(execution, 'output', output)