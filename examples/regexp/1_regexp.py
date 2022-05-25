import re

string = "Hello shitty! Do you know where someshit? Hello pritty! Look around and you can find some. Give me 5 dollars for information."
colors = "#FFaa55, #ccdd22, #32AA22, #QQ3333"

# .   - any char except \n, in [] like just .
# \d  - any numeric
# \D  - except any numeric
# \s  - Unicde any space char, ASCII any char class [\t\n\r\f\v]
# \S  - Unicde any char except space, ASCII any char class [^\t\n\r\f\v]
# \w  - Unicde any alphabet and numeric char, ASCII any char class [a-zA-Z0-9]
# \W  - Unicde any char except alphabet and numeric, ASCII any char class [^a-zA-Z0-9]

#match = re.findall("shit", string)           ==> shit, shit
#match = re.findall("\\bsome\\b", string)     ==> some 
#match = re.findall(r"\bsome\b", string)      ==> some
#match = re.findall(r"...tty", string)        ==> shitty, pritty

#match = re.findall(r"[sp][hr]itty", string)  ==> shitty, pritty
#match = re.findall(r"[0-9]", string)         ==> 5
#match = re.findall(r"\d", string)            ==> 5
#match = re.findall(r"[^0-9]", string)        ==> all without number 5
#match = re.findall(r"\D", string)            ==> all without number 5
#match = re.findall(r"\W", string, re.ASCII)  ==> all chars except alphabet and numeric
#match = re.findall(r"#[\da-fA-F]{6}", colors) ==> ['#FFaa55', '#ccdd22', '#32AA22']
match = re.findall(r"#[\da-fA-F]{6}", colors) 
print(match)

