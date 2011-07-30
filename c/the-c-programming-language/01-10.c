/* タブを"\\t"、バックスペースを"\\b"、バックスラッシュを"\\" と印字する */
#include <stdio.h>

int
main () {
  int c;

  while ((c = getchar()) != EOF) {
    /* else使っちゃ駄目なのだろうか */

    if (c == '\t') {
      printf("\\t");
    }
    if (c != '\t') {
      if (c == '\b') {
        printf("\\b");
      }
      if (c != '\b') {
        if (c == '\\') {
          printf("\\\\");
        }
        if (c != '\\') {
          putchar(c);
        }
      }
    }
  }

  return 0;
}





