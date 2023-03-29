def cipher(text,number):
    result = ""
    for char in text:
        if char.isalpha() and char.islower():
            result += chr((ord(char) + number - ord('a'))%26 + ord('a'))
        elif char.isalpha() and char.isupper():
            result += chr((ord(char) + number - ord('A'))%26 + ord('A'))

        else:
            result += char
        
    return result
    
text = input("Enter the text to get ciphered result: ")
number = int(input("Enter by what number you want the text to shift for ciphering (between 1 and 25): "))

print(cipher(text,number))
