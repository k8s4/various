def varName, varID, varDescription
def group_obj
from_id_group = CHANGEGROUPID
to_id_group = CHANGEGROUPID

//group_obj = daletAPI.UserService().getAllGroups()
group_obj = daletAPI.UserService().getUsersByGroup((id_group).toLong())

varID = group_obj.id
varName = group_obj.each {  daletAPI.UserService().addUserToGroup((it.id).toLong(), (to_id_group).toLong()) }

context.setVariable(execution, 'varName', varName)
context.setVariable(execution, 'varID', varID.toString())
context.setVariable(execution, 'varDescription', varDescription)