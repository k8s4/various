# Asyncio, async/await
# aiohttp
# Event Loop:
#    coroutine > Task(Future)
# python 3.4 and >

import asyncio
import inspect
from time import time

@asyncio.coroutine
def print_nums():
    num = 1
    while True:
        print(num)
        num += 1
        yield from asyncio.sleep(1)


@asyncio.coroutine
def print_time():
    count = 0
    while True:
        if count % 3 == 0:
            print("{} seconds have passed".format(count))
        count += 1
        yield from asyncio.sleep(1)

@asyncio.coroutine
def main():
    task1 = asyncio.ensure_future(print_nums())
    task2 = asyncio.ensure_future(print_time())
    yield from asyncio.gather(task1, task2)    

################# > python 3.4

async def print_nums2():
    num = 1
    while True:
        print(num)
        num += 1
        await asyncio.sleep(1)

async def print_time2():
    count = 0
    while True:
        if count % 3 == 0:
            print("{} seconds have passed".format(count))
        count += 1
        await asyncio.sleep(1)

async def main2():
    task1 = asyncio.create_task(print_nums2())
    task2 = asyncio.create_task(print_time2())
    await asyncio.gather(task1, task2)

if __name__ == '__main__':
    print(inspect.isgeneratorfunction(print_nums()))
#    loop = asyncio.get_event_loop()
#    loop.run_until_complete(main())
#    loop.close()
    asyncio.run(main2())

