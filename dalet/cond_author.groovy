def inputAuthor 
inputAuthor = [[Get Order Author.assetInfoValue]]
String[] allAuthors = ["Ivanov Ivan", "Sidorov Sidr"]
int flag = 0

for(item in allAuthors) {
     if (item == inputAuthor) {
      flag = 1
     }
}
context.setVariable(execution, 'output', flag)

