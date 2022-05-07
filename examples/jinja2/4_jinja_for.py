from jinja2 import Template

manufacturers = [
        {'id': 1, 'manufacturer': 'Hyundai'},
        {'id': 4, 'manufacturer': 'BMW'},
        {'id': 7, 'manufacturer': 'Mersedes'},
        {'id': 11, 'manufacturer': 'Citroen'},
        {'id': 17, 'manufacturer': 'Lada'},
        {'id': 32, 'manufacturer': 'Kamaz'}
        ]

exceptions = {1, 11}

data = '''<select name=manufacturers>
{% for m in manufacturers -%}
    {% set flag = "False" -%}
    {% for e in exceptions -%}
        {% if m.id == e -%}
            {% set flag = "True" %}
        {% endif -%}
    {% endfor -%}
    {% if flag == "False" -%}
        <option value="{{ m['id'] }}">{{ m['manufacturer'] }}</option>
    {% endif -%}
{% endfor -%}
</select>'''


template = Template(data)
message = template.render(manufacturers = manufacturers, exceptions = exceptions)

print(message)
