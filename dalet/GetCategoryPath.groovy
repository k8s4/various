def output, obj_category
// Get Category ID
long categoryid = ([[Get Title Metadata.assetInfoValue]]).toLong()
// Get Category Object by ID
obj_category = daletAPI.CategoryService().getCategory(categoryid)
// Get Category Full Path
fullPath = obj_category.fullName.toString()
// Output
context.setVariable(execution, 'output', fullPath.substring(11))