"""
This script is for testing zabbix version
by version of the docs on the logon page
"""

import re
from bs4 import BeautifulSoup
from urllib.request import urlopen

zab_page='http://0.0.0.0/zabbix/index.php'
page=urlopen(zab_page)
soup = BeautifulSoup(page, 'html.parser')
for link in soup.findAll('a', attrs={'href': re.compile("documentation")}):
    version=link.get('href')

parts=re.split('/', version)

a=''.join (parts[4:5])
print("zabbix version is",a)