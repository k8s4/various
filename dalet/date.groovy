import groovy.time.TimeCategory
def output, date
date = [[Get Title Metadata.assetInfoValue]]

if(date == null) {
    output = "no date"
} else {
    use (groovy.time.TimeCategory) {
        output = new Date().parse("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", date) 
////        output = output + 3.hours
    }
}
context.setVariable(execution, 'output', output)

