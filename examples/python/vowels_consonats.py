glass = {"а", "у", "о", "и", "э", "ы", "я", "ю", "е", "ё"}
soglass = {"б", "в", "г", "д", "ж", "з", "к", "л", "м", "н", "п", "р", "с", "т", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ь", "й"}

def count_vowels_and_consonants(text: str):
    glass_count = 0 
    soglass_count = 0
    temp = text.lower()
    for char in temp:
        if char in glass:
            glass_count = glass_count + 1
        if char in soglass:
            soglass_count = soglass_count + 1
    return glass_count, soglass_count

input_string = "Вы работаете над платформой для анализа текста на русском языке."
vowels, consonants = count_vowels_and_consonants(input_string)
print(vowels, consonants)

