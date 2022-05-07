from jinja2 import Template

data = '''{% raw %}Raw block
test var in {{ var }}
final line!{% endraw %}'''

shield = '''Some link for html: 
<a href="#">Link</a>'''

template = Template(data)
message = template.render(var="Someshit")

template2 = Template("{{ shield | e }}")
message2 = template2.render(shield=shield)

print(message)
print(message2)
