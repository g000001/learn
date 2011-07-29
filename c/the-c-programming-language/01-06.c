#include <stdio.h>

main ()
{
  int c;
  int is_eof;

  while (is_eof = ((c = getchar()) != EOF)) {
    printf("(c = getchar()) => %d\n", is_eof);
  }
  printf("(c = getchar()) => %d\n", is_eof);
}
