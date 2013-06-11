#include <stdio.h>

void call_func(void);

int
main () 
{
	printf("Now, I am in main\n");
	call_func();
	printf("Now, I am back in main.\n");
	printf("And that's all I am going to do for now!\n");
}

void call_func(void)
{
	printf("Now, I am not...\n");
}