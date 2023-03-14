def ifValid(str):

    symbol = []
    for i in str:
        if i in ["(", "[", "{"]:
            symbol.append(i)
            #print(symbol)

        elif i == "}" and symbol[-1] == "{":
            symbol.pop()
            
        elif i == "]" and symbol[-1] == "[":
            symbol.pop()
            
        elif i == ")" and symbol[-1] == "(":
            symbol.pop()

        else:
            return False

    if symbol != []:
        return "Backets are not closed properly"
    
    else:
        return True

while True:  # Run the loop indefinitely
    str = input("Enter the brackets (enter 'q' to quit): ")
    if str.lower() == 'q':  # Check if the user wants to quit
        break  # Break out of the loop
    print(ifValid(str))  # Print the result of the function
