from random import randrange

rand = []
for i in range(0,10000000):
    rand.append(randrange(9))

f = open("test.txt", "a")
f.write(str(rand))
f.close()
