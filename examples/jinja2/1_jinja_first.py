from jinja2 import Template 

name = "vasiliy" 
gender = "overweight man with boobs"

template = Template("Hello! My name is {{ var.capitalize() }}, and I am {{ var2.capitalize() }}") 
message = template.render(var=name, var2=gender) 

print(message) 

