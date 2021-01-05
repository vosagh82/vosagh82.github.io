#task FizzBuzz

for n in range(1, 18):
    if n%3==0 and n%5==0:
        print("fifteen")
    elif n%3==0:
        print('three')
    elif n%5==0:
        print('five')
    else:
        print(n)
