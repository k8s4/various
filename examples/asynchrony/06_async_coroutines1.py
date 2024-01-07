# Coroutines, yield, next, send, throw(send some exception)
# + custom Exception
# + custom decorator

from inspect import getgeneratorstate

def subgen():
    x = "Ready to start"
    message = yield x
    print("Subgen received: ", message)

g = subgen()
#g.send("fwefwef")
print("1.", getgeneratorstate(g))

print("2.", g.send(None))
#or the same: next(g)
print("3.", getgeneratorstate(g))

#g.send("OK")

###################################

def coroutine(func):
    def inner(*args, **kwargs):
        g = func(*args, **kwargs)
        g.send(None)
        return g
    return inner

class ShitException(Exception):
    pass

@coroutine
def average():
    count = 0
    summ = 0
    average = None

    while True:
        try:
            x = yield average
        except StopIteration:
            print("Done")
            break
        except ShitException:
            print("Some shit in the water")
        else:
            count += 1
            summ += x
            average = round(summ / count, 2)
            print(average)
    return average

a = average()
a.send(4)
a.send(10)
a.send(9)
a.send(20)
#a.throw(StopIteration)
a.throw(ShitException)
a.send(20)
print(getgeneratorstate(a))

try:
    a.throw(StopIteration)
except StopIteration as exc:
    print("Average:", exc.value)
print(getgeneratorstate(a))





