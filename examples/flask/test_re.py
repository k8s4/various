import re

text = "<p>The test img shitty</p><br><img src='qwl.jpeg'><br>"
#(?P<tag><img\s+[^>]*src=)
#(?P<quote>[\"'])
#(?P<url>.+?)
#(?P=quote)>

result = re.sub(r"(?P<tag><img\s+[^>]*src=)(?P<quote>[\"'])(?P<url>.+?)(?P=quote)>",
             "\\g<tag>\'" + base + "/\\g<url>\'>",
             text)

print(result)

