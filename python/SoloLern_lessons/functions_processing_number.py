print(min(1, 2, 4, 5, 3, 2))
print(max(1, 2, 4, 5, 3, 2))
print(abs(-99))
print(abs(43))
print(sum([1, 2, 3, 4]))



num = [55, 44, 33, 22, 11]

if all([i > 5 for i in num]):
    print("All lagra than 5")

if any([i%2 == 0 for i in num]):
    print("At least one is even")
