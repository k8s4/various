import re

# ^         - start of text (with re.MULTILINE start of line)
# $         - end of text (with re.MULTILINE end of line, previous position before \n)
# \A        - start of text
# \Z        - end of text
# \b        - word bound (in [] like BACKSPACE)
# \B        - not word bound (depends of re.ASCII)
# (?=exp)   - match exp in line continuation
# (?!exp)   - opposite match exp in line continuation
# (?<=exp)  - match exp positive retrospective check
# (?<!exp)  - opposite exp porsitive retrospective check

# (?P<name>[\"']) ==> (?(id|name)yes_pattern|no_pattern)

# Flags
# re.A or re.ASCII          - \b,\B,\s,\S,\w,\W like in ASCII, not UNICODE
# re.I or re.IGNORECASE     - Ignore case sensitive
# re.M or re.Multiline      - affect ^ and $ in multiline, depends on \n
# re.S or re.DOTALL         - with it the char . included \n
# re.X or re.VERBOSE        - allow to include spaces and comments into regexp
# re.DEBUG                  - Debug

# Flags into the regexp (?flags)
# a - re.ASCII
# i - re.IGNORECASE
# m - re.MULTILINE
# s - re.DOTALL
# x - re.VERBOSE

text = "someshits in the hole, shit"
html = """<!DOCTYPE html>
<html><head>
<meta http-equiv="Content-Type" content="text/html" charset="windows-1251">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Someshit</title></head><body>
<script type="text/javascript">
let o = document.getElementById('id_div');
console.log(obj);
</script>
<p align=center>Hello Shitty!</p>
</body></html>"""
flags = "Shit, SHIT, shit"

#match = re.findall(r"\bshit\b|\bknow\b|\bsome\b", text)        ==> find just "shit", not "someshits", use check \b 
#match = re.findall(r"\b(shit|know|some)\b", text)              ==> Better, ['shit']

#match = re.findall(r"^<script.*?>([\w\W]+)(?=</script>)", html, re.MULTILINE)              ==> ahead check (?=exp) ["\nlet o = document.getElementById('id_div');\nconsole.log(obj);\n"]
#match = re.findall(r"^<script.*?>([\w\W]+)(?<=</script>)", html, re.MULTILINE)             ==> retro check (?<=exp) ["\nlet o = document.getElementById('id_div');\nconsole.log(obj);\n</script>"]
#match = re.findall(r"([-\w]+)[ \t]*=[ \t]*[\"']([^\"']+)(?<![ \t])", html, re.MULTILINE)    ==> opposite retro check (?<!exp) [('http-equiv', 'Content-Type'), ('content', 'text/html'), ('charset', 'windows-1251'), ('name', 'viewport'), ('content', 'width=device-width, initial-scale=1.0'), ('type', 'text/javascript')]
#match = re.findall(r"([-\w]+)[ \t]*=[ \t]*(?P<name>[\"'])?(?(name)([^\"']+(?<![ \t]))|([^ \t>]+))", html, re.MULTILINE)
match = re.findall(r"""([-\w]+)         # Pick out attribute
                    [ \t]*=[ \t]*       # equality and quote
                    (?P<name>[\"'])?    # check quote
                    (?(name)([^\"']+(?<![ \t]))|([^ \t>]+)) # Pickout value of attribute
                    """,
                    html, re.MULTILINE|re.VERBOSE)
match = re.findall(r"(?im)shit", flags)

print(match)
