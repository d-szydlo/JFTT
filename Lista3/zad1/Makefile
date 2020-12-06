all: zad1

zad1: 	zad1.l
	flex -o zad1.c zad1.l
	bison -d zad1.y
	gcc -o zad1 zad1.c zad1.tab.c -lfl


clean:
	rm *.c *.h zad1
