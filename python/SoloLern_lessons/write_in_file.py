file = open("test2.txt", "w")
msg = file.write("test maseges")
file.close()
print(msg)# show haw much bit write
file = open("test2.txt", "r")
print(file.read())
file.close()
