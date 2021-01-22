primary = {
    "red":[245, 0, 5],
    "blue":[0,344,4]
}
print(primary["red"])
print(primary["blue"])


squares = {1: 1, 2: 4, 3: "error", 4: 16,}
squares[8] = 64
squares[3] = 9
print(squares)


num = {
    1: "one",
    2: "two",
    3: "three"
}

print(1 in num)
print("tree" in num)
print(4 not in num)
print(num.get(3,0))
