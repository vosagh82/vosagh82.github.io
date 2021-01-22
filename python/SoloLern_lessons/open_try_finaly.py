#Always close file
try:
    f = open("test.txt")
    print(f.read())
    #print(1/0)
finally:
    f.close()
#similar use with
with open("test.txt") as f:
    print(f.read())
