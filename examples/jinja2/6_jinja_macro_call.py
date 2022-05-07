from jinja2 import Template 

# DRY - Don't Repeat Yourself!

html = '''
{% macro input(name, value='', type='text', size=20) -%}
    <input tupe="{{ type }} name="{{ name }}" value="{{ value | e }}" size="{{ size }}">
{%- endmacro %}

<p>{{ input("username") }}</p>
<p>{{ input("email") }}</p>
<p>{{ input("phone") }}</p>
'''

template = Template(html) 
message = template.render() 

print(message) 

persons = [
    {"name":"Arkady", "age": 22, "weight": 55.6},
    {"name":"Metropolit", "age": 54, "weight": 90.1},
    {"name":"Sergo", "age": 43, "weight": 110.7},
    {"name":"Murad", "age": 29, "weight": 81.4}
]

html2 = '''
{% macro list_users(list_of_users) -%}
<ul>
{% for u in list_of_users -%}
    <li>{{ u.name }} {{ caller(u) }}
{%- endfor %}
</ul>
{%- endmacro%}

{# {{ list_users(users) }} #}

{% call(user) list_users(users) %}
    <ul>
    <li>Age: {{ user.age }}
    <li>Weight: {{ user.weight }}
{% endcall %}
'''

template2 = Template(html2) 
message2 = template2.render(users = persons) 

print(message2) 

