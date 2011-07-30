/* count space or newline or tab */
#include <stdio.h>

int
main ()
{
  int c;
  double cnt;

  while((c = getchar()) != EOF) {
    if (c == '\n') {
      ++cnt;
    }
    /* || は まだ出てきていない */
    if (c == '\t') {
      ++cnt;
    }
    if (c == ' ') {
      ++cnt;
    }
  }

  printf("%.0f\n", cnt);

  return 0;
}

