# Generators!!!
from time import time

def gen_filename():
    while True:
        pattern = 'file-{}.jpg'
        t = int(time() * 1000)
        yield pattern.format(str(t))
        sum = 123 + 123
        print(sum)
g = gen_filename()
#print(next(g))
#print(next(g))

def some():
    yield 1
    yield 2
    yield 3
    yield 4
g = some()
#print(next(g))
#print(next(g))
#print(next(g))
#print(next(g))


# Event Loop Round Robin
def gen1(s):
    for i in s:
        yield i

def gen2(n):
    for i in range(n):
        yield i

g1 = gen1("fuck")
g2 = gen2(4)

tasks = [g1, g2]
while tasks:
    task = tasks.pop(0)
    try:
        i = next(task)
        print(i)
        tasks.append(task)
    except StopIteration:
        pass

