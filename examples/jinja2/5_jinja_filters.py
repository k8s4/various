from jinja2 import Template 

numbers = {1,2,3,4,5}

data = "{{ numbers | sum }}"
data2 = "{% filter upper %}someshit{% endfilter %}"

template = Template(data) 
message = template.render(numbers = numbers) 

print(message) 

remarks = '''{# Jinja filters:

abs()
attr()
batch()
capitalize()
center()
default()
dictsort()
escape()
filesizeformat()
first()
float()
forceescape()
format() ******
groupby() ******
indent() ******
int()
join() ******
last() 
length()
list() ******
lower()
map()
max()
min()
pprint()
random()
reject()
rejectattr()
replace() ******
reverse()
round()
safe()
select() ******
selectattr()
slice()
sort() ******
string()
striptags()
sum()
title()
tojson() ******
trim()
truncate()
unique() ******
upper() ******
urlencode()
urlize()
wordcount()
wordwrap()
xmlattr()

#}'''
