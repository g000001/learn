/* two spaces to one space */
#include <stdio.h>

int
main ()
{
  int c, prev_c;

  while((c = getchar()) != EOF) {
    /* ' '以外の場合 */
    if (c != ' ') {
      putchar(c);
    }
    /* ' 'の場合 (elseがまだ出てきていない) */
    if (c == ' ') {
      if (prev_c != ' ') {
        putchar(' ');
      }
    }
    prev_c = c;
  }

  return 0;
}

