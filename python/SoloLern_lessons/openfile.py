#open and print file test.txt and close
text=open("test.txt", "r")
print(text.read(2)) #read firs 2 symbol
print(text.read()) #read all after
text.close() #close file
