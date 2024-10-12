def process(input_string: str) -> str:
    positive = 0
    negative = 0
    zero = 0
    data = input_string.split(" ")
    for item in data:
        check = int(item)
        if check < 0:
            negative = negative + 1
        elif check > 0:
            positive = positive + 1
        else:
            zero = zero + 1
            
    return "выше нуля: {}, ниже нуля: {}, равна нулю: {}".format(positive, negative, zero)
 
input_string = "1 -2 -5 7 0 8 0"
output_string = process(input_string)
print(output_string)
