#find the most long word in test

txt =input('Enter file name Exemple test2.txt :')

with open(txt) as f:
        st = (f.read()).split()

#st=txt.spilt()
count=0
for i in st:
    if len(i)>count:
        count=len(i)
        word=i
print(word)
