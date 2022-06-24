class Creature:
    def __init__(self, name):
        self.name = name

class SwimmerInterface:
    def swim():
        pass

class WalkerInterface:
    def walk():
        pass
    def run():
        pass

class TalkerrInterface:
    def talk():
        pass

class Human(Creature, SwimmerInterface, WalkerInterface, TalkerrInterface):
    def __init__(self, name):
        super().__init__(name)

    def swim(self):
        print(f"I'm {self.name} and I can swim")

    def talk(self):
        print(f"I'm {self.name} and I can swim")

    def walk(self):
        print(f"I'm {self.name} and I can swim")

class Fish(Creature, SwimmerInterface):
    def __init__(self, name):
        super().__init__(name)

    def swim(self):
        print(f"I'm {self.name} and I can swim")
    
class Cat(Creature, SwimmerInterface, WalkerInterface):
    def __init__(self, name):
        super().__init__(name)

    def swim(self):
        print(f"I'm {self.name} and I can swim")
    
    def walk(self):
        print(f"I'm {self.name} and I can swim")

human = Human("Ivan Ivanov")
human.swim()
human.talk()
human.walk()

fish = Fish("Lolo")
fish.swim()

cat = Cat("Murich")
cat.walk()
cat.swim()

