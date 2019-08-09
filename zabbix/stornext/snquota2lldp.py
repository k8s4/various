import os
import time
import json
import sys
import base64
import requests
from requests.auth import HTTPBasicAuth
import urllib3
import logging
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def str2base64(s):
    return base64.b64encode(s)

def base642str(b):
    return base64.b64decode(b)

def Discovery(ip):
    Download(ip)
    with open(tmpfile, 'r') as file:
        data = json.load(file)
    for key in data["directoryQuotas"]:
        if key["type"] == "dir":
            res.append({"{#INDEXNAME}": key["name"]})
    return {"data": res}

def Get(ip, indexname, keyname):
    Download(ip)
    with open(tmpfile, 'r') as file:
        data = json.load(file)
    for key in data["directoryQuotas"]:
        if key["type"] == "dir" and key["name"] == indexname:
            return NumConvert(key[keyname])

def NumConvert(num):
    #num = num.replace('.' , ',')
    if num[-1:] == "K":
        result = (float(num[:-1]) / 1024)
    elif num[-1:] == "M":
        result = (float(num[:-1]) / 1024 / 1024)
    elif num[-1:] == "G":
        result = (float(num[:-1]))
    elif num[-1:] == "T":
        result = (float(num[:-1]) * 1024)
    else:
        result = 0
    return int(result)

def Download(ip):
    current = time.time()
    get = 0
    if os.path.isfile(tmpfile):
        get = os.stat(tmpfile).st_mtime
    if (current - get) > 3600 or not os.path.isfile(tmpfile):
        url = requests.get('https://' + ip + '/sws/v2/quota/snquota?username=' + user + '&password=' + password + '&fsname=XS&action=listall&format=json', verify=False)
        data = url.json()
        f = open(tmpfile, "w+")
        f.write(json.dumps(data))
        f.close()

res = []
tmpfile = '/tmp/snquotafile.txt'
logfile = '/tmp/snquotalogfile.txt'
user = sys.argv[1]
password = base642str(sys.argv[2].encode()).decode()

logging.basicConfig(filename=logfile, level=logging.INFO, format='%(asctime)s %(message)s')

if len(sys.argv) <= 1:
    print('USAGE: script mode')
    print('    modes: ')
    print('       discovery: lldp for zabbix')
    print('       get: get values by indexname, keyname(hardLimit,softLimit,curSize)')
    print('    example: '+ sys.argv[0] +' user password 192.168.0.1 get /DESIGN, curSize')
    print('    exapmle: '+ sys.argv[0] +' user password(base64) 192.168.0.1 discovery')
else:
    if sys.argv[4] == "discovery" and len(sys.argv) == 5:
        print(json.dumps(Discovery(sys.argv[3])).replace("'", '"').replace(' ', '') )
#        logging.info("- " + sys.argv[1] + "; "+ sys.argv[2] + "; "+ sys.argv[3] + "; " + sys.argv[4])
    elif sys.argv[4] == "get" and len(sys.argv) == 7:
        print(Get(sys.argv[3], sys.argv[5], sys.argv[6]))
#        logging.info("- " + sys.argv[1] + "; "+ sys.argv[2] + "; "+ sys.argv[3] + "; " + sys.argv[4] + "; " + sys.argv[5] + "; " + sys.argv[6])
    else:
        print("Error: bad parameters")

