class Animal:
    def __init__(self, name, age):
        self.attributes = {"name": name, "age": age}

    def eat(self, _amount = 0):
        print("Animal ate some food!")

class Cat(Animal):
    def __init__(self, name, age):
        super().__init__(name, age)

    def eat(self, amount = 0.2):
        if amount > 0.3:
            print("Can't eat more stupid!")
        else:
            print("Cat ate some food!")

class Dog(Animal):
    def __init__(self, name, age):
        super().__init__(name, age)

    def eat(self, _amount = 0):
        print("Dog ate some food!")

pluto = Dog("Pluto", 3)
goofy = Dog("Goofy", 2)
buttons = Cat("Mr. Buttons", 4)

animals = (pluto, goofy, buttons)

for animal in animals:
    if animal.attributes["age"] > 2:
        print(animal.attributes["name"])

