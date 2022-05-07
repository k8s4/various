from jinja2 import Environment, FileSystemLoader, FunctionLoader

persons = [
    {"name":"Arkady", "age": 22, "weight": 55.6},
    {"name":"Metropolit", "age": 54, "weight": 90.1},
    {"name":"Sergo", "age": 43, "weight": 110.7},
    {"name":"Murad", "age": 29, "weight": 81.4}
]

def loadTemplate(path):
    if path == "index":
        return '''Name {{ u.name }}, age: {{ u.age }}'''
    else:
        return '''Data: {{ u }}'''

file_loader = FunctionLoader(loadTemplate)
env = Environment(loader = file_loader)

template = env.get_template("index")
message = template.render(u = persons[0])

print(message)

