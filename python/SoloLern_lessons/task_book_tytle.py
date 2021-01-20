#Create program with read title book and print thy namber
file = open("book.txt", "r")

#b = len(file.readlines())
#for i in range(10):
#    b=file.readlines(1)
#    print(b.read(1))
    #print(file.read(1))

for line in file:
    #f = (file.read(1))
    #f = line.readlines(1)
    #print(f)
    f = line[0]
    b = len(line.rstrip('\n'))#  rstrip removes the newline character
    c = f + str(b)
    #print(line[0]+str(len(line)))
    #print(line)
    print(c)

file.close()
