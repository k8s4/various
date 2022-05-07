from jinja2 import Environment, FileSystemLoader

persons = [
    {"name":"Arkady", "age": 22, "weight": 55.6},
    {"name":"Metropolit", "age": 54, "weight": 90.1},
    {"name":"Sergo", "age": 43, "weight": 110.7},
    {"name":"Murad", "age": 29, "weight": 81.4}
]

file_loader = FileSystemLoader('templates')
env = Environment(loader = file_loader)

#template = env.get_template("main.html")
#message = template.render(users = persons)

template = env.get_template("content.html")
message = template.render(domain="http://supershit.local", title="Hello shitty", users = persons)

print(message)


remarks = '''
FileSystemLoader - Templates from file
PackageLoader  - Templates from package
DictLoader     - Templates from dicts
FunctionLoader - Load based on functions
PrefixLoader   - Using dict for make subfolders
ChoiceLoader   - Having list other loaders one by one
ModuleLoader   - For compiled templates
'''
