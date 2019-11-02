#include <stdio.h>

int
main() 
{
	static int zilch[] = {1,2,3,4,5,6};
	int i = 0;
	putchar('\n');
	while(i <= 5)
	{
		printf("zilch %d th: value = %d, address = %u\n", i, zilch[i], &zilch[i]);
		++i;
	}

	return 0;

}