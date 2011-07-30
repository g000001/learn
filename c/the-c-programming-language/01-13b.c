#include <stdio.h>

#define WORD_LEN_MAX 26

int
main () {
  int c;
  int i, j;
  int wlen;
  int total[WORD_LEN_MAX];
  int most = 0;

  /* init total */
  for (i = 0; i < WORD_LEN_MAX; ++i) {
    total[i] = 0;
  }

  wlen = 0;                     /* 初期化しないでsegmentation faultの思い出 */
  while ((c = getchar()) != EOF) {
    if ((c == ' ') || (c == '\t') || (c == '\n')) {
      ++total[wlen];
      wlen = 0;
    } else {
      ++wlen;
    }
  }

  /* print virtical histogram */

  /* find most */
  for (i = 1; i < WORD_LEN_MAX; ++i) {
    if (total[i] > most) {
      most = total[i];
    }
  }

  /* print */
  for (i = most; i > 0; --i) {
    for (j = 1; j < WORD_LEN_MAX; ++j) {
      if (total[j] >= i) {
        printf(" * ", i);
      } else {
        printf("   ");
      }
    }
    putchar('\n');
  }

  /* label */
  for (i = 1; i < WORD_LEN_MAX; ++i) {
    printf("%02d ", i);
  }

  return 0;
}
