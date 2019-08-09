def output
Date date = new Date()
String datePart = date.format("dd.MM.yyyy")
String datePartOutput = date.format("yyyy-MM-dd")
String timePart = date.format("HH:mm:ss")
output = datePart + " " + timePart
context.setVariable(execution, 'output', output)
context.setVariable(execution, 'datePartOutput', datePartOutput)