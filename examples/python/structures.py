from dataclasses import dataclass
from collections import namedtuple
from typing import NamedTuple

@dataclass
class SomeRecords:
  id: int 
  days: int
  price: int

class SomeNamedTuples(NamedTuple):
  id: int 
  days: int
  price: int

# named tuple
named_tuple = namedtuple('Record', 'id days price')


# array, list
a = ["super", "fucker", "maker"]
a = [['1','2','3'], ['d','r','a'],['some','meso','semo']]

# tuple ro
c = ('someshit', 'greate', 'goodness')

# set unique
d = set(['10','44','66','22','11'])

# dict
b = {'name': 'Fuker', 'age': '44', 'gender': 'male'}
# hash table
e = {hash('Fucker'): 'Fuker', hash('Sucker'): 'Sucker', hash('Maker'): 'Maker'}

# stack FILO

# queue LILO
# priority queue

# binary tree (Haffman compression)

# prefix tree

# graf

# vertors

# matrix

print(e)

