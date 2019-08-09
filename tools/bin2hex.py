import re
print('Enter string')
varString = input()  					# Get string from user
varArray = re.findall('........', varString)		# Split string by 8 bit
varTemp = [int(i, 2) for i in varArray]			# Convert binary to decimal
varByteArray = bytearray(varTemp)			# Convert decimal to bytecode
#print(varByteArray)
f = open('result.txt', 'wb')				# Write bytecode to file
f.write(varByteArray)
f.close()
