#include <stdio.h>

int
main() 
{
	int *carter;
	int kennedy;

	kennedy = 65;
	carter = &kennedy;

	printf("The value stored at kennedy is %d\n", kennedy);
	printf("The value stored at kennedy is %d\n", *(carter));
	printf("The value stored at kennedy is %d\n", *(&kennedy));

	return 0;

}