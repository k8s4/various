def categorize_students(scores_input: str)-> str:
    a = 0
    b = 0
    c = 0
    scores_list = scores_input.split(",")
    for i in scores_list:
        i = int(i)
        if i >= 50:
            a = a + 1
        elif i < 35:
            c = c + 1
        else:
            b = b + 1
    return "Отлично: {0}\nХорошо: {1}\nНеудовлетворительно: {2}".format(a, b, c)

scores_input = "30,53,45,39"
result = categorize_students(scores_input)
print(result)

