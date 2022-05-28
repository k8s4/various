import re

with open("map.xml", "r") as f:
    lat = []
    lon = []
    for data in f:
#        match = re.findall(r"<point\s+[^>]*?lat=([\"\'])([0-9.,]+)\1\s+[^>]*lon=([\"\'])([0-9.,]+)\1", data)
#        if len(match) > 0:
#            lat.append(match[0][1])
#            lon.append(match[0][3])
        match = re.search(r"<point\s+[^>]*?lat=([\"\'])(?P<lat>[0-9.,]+)\1\s+[^>]*lon=([\"\'])(?P<lon>[0-9.,]+)\1", data)
        if match:
            s = match.groupdict()
            if "lat" in s and "lon" in s:
                lat.append(s["lat"])
                lon.append(s["lon"])

    print(lat, lon, sep="\n")
