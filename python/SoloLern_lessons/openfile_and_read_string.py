file = open("test.txt", "r")
#print(file.readlines())
for line in file:
    print(line)
file.close()
