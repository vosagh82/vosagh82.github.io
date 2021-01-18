file = open("test.txt", "r")
for i in range(24):
    print(file.read(4))
file.close()
