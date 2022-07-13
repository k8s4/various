from tarantool import Connection
c = Connection(
    "1.1.1.1", 
    31013,
    user='admin', 
    password='****'
)
space = c.space("myspace")
result = c.insert("myspace", (332, 'John Smith'))
results = space.select()
print(results)
