#include <stdio.h> 

void roman(int arabic);
int romanize(int i, int j, char c);

int
main() {
	int i = 1;

	while(i <= 25)
	{
		roman(i);
		i = i +1;
	}
}