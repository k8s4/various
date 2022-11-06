colors = ['black', 'white']
sizes = ['S', 'M', 'L']

result = [(color, size) for color in colors for size in sizes]
print(result)

result = [(color, size) for size in sizes for color in colors]
print(result)

# Iteration
for color in colors:
  for size in sizes:
    print((color, size))


suits = ['hearts', 'diamonds', 'clubs', 'spades']
ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king', 'ace']

# List Comprehension
cards = [(suit, rank) for suit in suits for rank in ranks ]
print(cards)

# Generator
for card in ('%s %s' % (s, r) for s in suits for r in ranks):
    print(card)

# Unpack tuple
coords = (33.9425, -118.408056)
latitude, longitude = coords
print(latitude)
print(longitude)

list = (24, 8)
print(divmod(*list))
print(list)

