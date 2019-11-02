#include <stdio.h>
#include <stdlib.h>

int int_int(int);
char char_char(char);
char* pchar_pchar(char*);

main ()
{
  int i = 42;
  char c = 'q';
  char *pc = "qqq";
  int inta[] = {42, 43, 44, 45};
  int *pint = inta;

  printf("int->int %d\n", int_int(i));
  printf("char->char %c\n", char_char(c));
  printf("char*->char* %s\n", pchar_pchar(pc));
  printf("int* %d\n", *(pint+1));

  // int int_a[] = {1,1,1,1};
  // int a_size = sizeof(int_a) / sizeof(*int_a);
  // print_array(int_a, 4);

  int a[] = {42, 43, 44, 45};
  int *int_a = a;
  // int a_size = sizeof(int_a) / sizeof(*int_a);
  print_array(a, 4);

  return 0;
}

void print_array(int *a, int size)
{
  printf("%d\n", size);
  putchar('{');
  int i = 0;
  while(i < size) {
    printf("%d, ", *(a+i));
    ++i;
  }
  printf("}\n");

}

char* pchar_pchar(char* pc)
{
  return pc;
}


char char_char(char c)
{
  return c;
}


int int_int(int i)
{
  return i;
}
