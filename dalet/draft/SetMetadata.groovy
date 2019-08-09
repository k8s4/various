import groovy.time.TimeCategory
import org.activiti.engine.delegate.BpmnError
import com.dalet.webservice.services.errors.ResourceDoesNotExist
import com.dalet.webservice.services.errors.ResourcePreconditionViolation
import org.apache.log4j.BasicConfigurator
import org.slf4j.LoggerFactory

// pkvs_PKAirDate ; 1976   pkvs_PKAirDate_DT ; 1975
def obj_asset, obj_enum, obj, obj_dst
def output2, output3, output4, output5 
def obj_log = LoggerFactory.getLogger('GetMetaDataScript')
def output = Calendar.getInstance()
def format_date = "yyyy-MM-dd HH:mm:ss"
def fileds_list = [1976]
long titleid = ([[Start event.titleID]]).toLong()

obj_asset = daletAPI.AssetService().getAsset(titleid)
obj_enum = com.dalet.webservice.services.metadataservice.definition.ObjectTypeEnum.ASSET
obj = daletAPI.MetadataService().getObjectMetadataByFields(obj_asset.id, obj_enum, fileds_list)
output5 = obj.getFirst()
output5.value.add(Calendar.HOUR_OF_DAY, 3)
output4 = output5.value 
	
// Delete all payload in type
//try {
//	output3 = daletAPI.MetadataService().removeMetadataFromObject(obj_asset.id, obj_enum, 1976)
//} catch (all) {
//	obj_log.error("Metadata is not remove.")
//	throw new BpmnError("Metadata is not remove.")
//}

// Add data to Multi type, type with unlimited cardinality 
//output2 = new com.dalet.webservice.services.metadataservice.definition.TimeDateAssetInfoMulti()
//output2.setDataFieldTagName("pkvs_PKAirDate_DT")
//output2.setDataFieldName("pkvs_PKAirDate_DT")
//output2.setDataFieldId(1975)
//output2.setValues([output])
//output4 = daletAPI.MetadataService().appendValueToObjects([obj_asset.id], obj_enum, output2)

// Add data to single type
output2 = new com.dalet.webservice.services.metadataservice.definition.TimeDateAssetInfo()
//output2.setDataFieldTagName("pkvs_PKAirDate_DT")
//output2.setDataFieldName("pkvs_PKAirDate_DT")
output2.setDataFieldId(1976)
output2.setValue(output4)
output4 = daletAPI.MetadataService().addMetadataToObject(obj_asset.id, obj_enum, [output2])

context.setVariable(execution, 'output', output.format(format_date).toString() + "\n")
context.setVariable(execution, 'output2', output2.toString() + "\n")
context.setVariable(execution, 'output3', output3.toString() + "\n")
context.setVariable(execution, 'output4', output4.format(format_date).toString() + "\n")
context.setVariable(execution, 'output5', output5.toString() + "\n")