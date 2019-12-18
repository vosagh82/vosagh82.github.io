import sys
def silly_age():
	print('Сколько вам лет?')
	age = int(sys.stdin.readline())
	if age >=10 and age <=13:
		print('голованая боль!')
	else:
		print('что!')
