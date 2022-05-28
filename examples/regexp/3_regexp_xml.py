import re

with open("map.xml", "r") as f:
    lat = []
    lon = []
    for data in f:
        match = re.findall(r"<point\s+[^>]*?lat=([\"\'])([0-9.,]+)\1\s+[^>]*lon=([\"\'])([0-9.,]+)\1", data)
        print(match)

    print(lat, lon, sep="\n")
