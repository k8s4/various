import re
# Instant compile and processing
# Attributes and Methods of Match
# re.search(pattern, string, flags)     # find first entry in oblect
# re.finditer(pattern, string, flag)    # find all entries in iterable object
# re.findall(pattern, string, flag)     # find all entries in tuple
# re.match(pattern, string, flag)       # find entry from first char in string, return object
# re.split(pattern)                     # split string by pattern

text = "<font color=#DD5566 bg=#101010>"
match = re.search(r"(\w+)=(#[\da-fA-F]{6})\b", text)
string = "someshit|shitsome"

# index 0                   - color=#DD5566
# index 1 (\w+)             - color
# index 2 (#[\da-fA-F]{6})  - #DD5566
print(match)
print(match.re)             # return regexp template
print(match.string)         # return applieng string

print(match.group(2))
print(match.group(0,1,2))   # return tuple of given indexes
print(match.groups())       # all indexes started from 1
print(match.lastindex)      # return last index (2)

print(match.start(1))       # return start char position of finded entry in string (6)
print(match.end(1))         # return end char position of finded entry in string (11)
print(match.span(1))        # return tuple with start and end positions of entry
print(match.start(2))       # (12) 'if not find then return -1
print(match.end(2))         # (19) 'if not find then return -1
print(match.span(2))        # return tuple with start and end positions of entry
print(match.pos)            # return start position in string
print(match.endpos)         # return end position in string
print(match.expand(r"\1:\2"))   # Make yml style from searched groups

match = re.search(r"(?P<key>\w+)=(?P<value>#[\da-fA-F]{6})\b", text)    # added names for groups
print(match.groupdict())    # return tuple with values and names
print(match.lastgroup)      # return last group name
print(match.expand(r"\g<key>:\g<value>"))   # Make yml style from searched groups with names


for match in re.finditer(r"(\w+)=(#[\da-fA-F]{6})\b", text):
    print(match)

match = re.split(r"\|", string) # return list 
print(match)
