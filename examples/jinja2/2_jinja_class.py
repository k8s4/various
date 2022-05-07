from jinja2 import Template 

class Car:
    def __init__(self, manufacturer, model):
        self.manufacturer = manufacturer
        self.model = model
    
    def getManufacturer(self):
        return self.manufacturer

    def getModel(self):
        return self.model

first = Car("Ford", "Focus")
second = { 'model': 'Creta', 'manufaturer': 'Hyundai' }

template = Template("My car is {{ c.getModel() }} from {{ c.getManufacturer() }}.")
message = template.render(c=first)

template2 = Template("My brother has {{ b.model }} from {{ b.manufaturer }}.")
message2 = template2.render(b=second)

print(message)
print(message2)

