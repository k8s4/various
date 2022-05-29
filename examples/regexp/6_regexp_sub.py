import re
# re.sub(pattern, repl, string, count, flags)
# re.subn(pattern, repl, string, count, flags)  # with count of replaces
# pattern   - r"some"
# repl      - replace sring or function
# string    - string for analyse
# count     - max replaces size, without value infinity
# flags     - standart flags

# re.compile(pattern, flags)    - compile regexp and return pattern object
# properties: flags, pattern, groupindex

cities = """Moscow
London
Tokyo
Paris
Boston"""

count = 0
def replFind(m): # get object from re.sub
    global count
    count += 1
    return f"<p class='{count}'>{m.group(1)}</p>\n"

print(re.sub(r"\s*(\w+)\s*", r"<p>\1</p>\n", cities))
print(re.subn(r"\s*(\w+)\s*", r"<p>\1</p>\n", cities))
print(re.sub(r"\s*(\w+)\s*", replFind, cities))

pattern = re.compile(r"\s*(\w+)\s*")
print(pattern.subn(replFind, cities))

