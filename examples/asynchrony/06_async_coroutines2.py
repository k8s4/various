# Coroutines, yield, next, send, throw(send some exception)
# Delegator
# yield from

def coroutine(func):
    def inner(*args, **kwargs):
        g = func(*args, **kwargs)
        g.send(None)
        return g
    return inner

class ShitException(Exception):
    pass


# reading generotor
def subgen():
    for i in 'penis':
        yield i

def delegator(g):
    for i in g:
        yield i

sg = subgen()
g = delegator(sg)

print(next(g))
print(next(g))
print(next(g))
print(next(g))
print(next(g))

#####################################################

# reading generotor
#@coroutine
def subgen2():
    while True:
        try:
            message = yield
        #except ShitException:
        except StopIteration:
            #print('shit happens')
            break
        else:
            print('-----', message)
    return 'Some shit returned from subgen2()'

@coroutine
def delegator2(g):
    #while True:
    #    try:
    #        data = yield
    #        g.send(data)
    #    except ShitException as e:
    #        g.throw(e)
    result = yield from g
    print(result)

sg2 = subgen2()
g2 = delegator2(sg2)

print(g2.send('some'))
print(g2.send('shit'))
print(g2.send('in'))
print(g2.throw(StopIteration))
print(g2.send('the'))
print(g2.send('water'))

