def output
Date date = new Date()
String datePart = date.format("dd.MM.yyyy")
String timePart = date.format("HH:mm:ss")
output = datePart + " " + timePart
def audioTitleIds = [[Get GE Bundle Content.audioTitleIds]].toArray()
output = audioTitleIds[0]
context.setVariable(execution, 'output', output)