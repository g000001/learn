#include <stdio.h>



int
main () {
  int a[32];
  int *p;
  a[0] = 30;
  a[1] = 35;
  p = a;
  printf("a => %p:\n", a);
  printf("&a[0] => %p:\n", &a[0]);
  printf("p => %p:\n", p);
  printf("=====\n");
  printf("a[0] => %d:\n", a[0]);
  printf("*p => %d:\n", *p);
  printf("*(++p) => %d:\n", *(++p));
  printf("*(a + 1) => %d:\n", *(a + 1));
  //  printf("*++p[0] => %d:\n", ++p[0]);
  return 0;
}
