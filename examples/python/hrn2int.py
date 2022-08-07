def NumConvert(num):
    if num[-1:] == "T":
        return (int(num[:-1]) * 1024 * 1024 * 1024 * 1024)
    elif num[-1:] == "G":
        return (int(num[:-1]) * 1024 * 1024 * 1024)
    elif num[-1:] == "M":
        return (int(num[:-1]) * 1024 * 1024)
    else:
        return 0

print(NumConvert("1T"))
print(NumConvert("10T"))
print(NumConvert("222T"))
print(NumConvert("455T"))
print(NumConvert("45M"))
print(NumConvert("34G"))
