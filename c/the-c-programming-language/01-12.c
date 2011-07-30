/* 入力した単語を一行に一つで印字する */

#include <stdio.h>

int
main () {
  int c;
  
  while ((c = getchar()) != EOF) {
    if ((c == ' ') || (c == '\t') || (c == '\n')) {
      putchar('\n');
    } else {
      putchar(c);
    }
  }

  return 0;
}
