#include <stdio.h> 

void roman(int arabic);
int romanize(int i, int j, char c);

void roman(int arabic)
{
	arabic = romanize(arabic, 1000, 'M');
	arabic = romanize(arabic, 500, 'D');
	arabic = romanize(arabic, 100, 'C');
	arabic = romanize(arabic, 50, 'L');
	arabic = romanize(arabic, 10, 'X');
	arabic = romanize(arabic, 5, 'V');
	arabic = romanize(arabic, 1, 'I');
	putchar('\n');
}
	

int romanize (int i, int j, char c)
{
	while(i >= j)
	{
		putchar(c);
		i = i - j;
	}
	return i;
}
	