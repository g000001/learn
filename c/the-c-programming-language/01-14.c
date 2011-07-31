#include <stdio.h>
#define CHAR_KINDS ('Z' + 1) /* A-Z ;Aより前の無駄は気にしない */
#define U2D ('a' - 'A')

int
main () {
  int c;
  int i, j;
  int wlen = 0;
  int total[CHAR_KINDS];
  int most = 0;

  /* init total */
  for (i = 0; i < CHAR_KINDS; ++i) {
    total[i] = 0;
  }

  while ((c = getchar()) != EOF) {
    if (('A' <= c) && (c <= 'Z')) {
      ++total[c];
    } else if (('a' <= c) && (c <= 'z')) {
      /* 小文字は大文字に直す */
      ++total[c - U2D];
    } else {
      /* その他 */
      ++total[0];
    }
  }

  /* print virtical histogram */

  /* find most */
  for (i = 'A'; i < CHAR_KINDS; ++i) {
    if (total[i] > most) {
      most = total[i];
    }
  }

  /* print */
  for (i = most; i > 0; --i) {
    for (j = 'A'; j < CHAR_KINDS; ++j) {
      if (total[j] >= i) {
        printf(" * ", i);
      } else {
        printf("   ");
      }
    }
    putchar('\n');
  }

  /* label */
  for (i = 'A'; i < CHAR_KINDS; ++i) {
    printf(" %c ", i);
  }

  return 0;
}
