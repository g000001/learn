#include <stdio.h>

#define WORD_LEN_MAX 26

int
main () {
  int c;
  int i, j;
  int wlen;
  int total[WORD_LEN_MAX];

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

  /* print histogram */
  for (i = 1; i < WORD_LEN_MAX; ++i) {
    printf("%02d:", i);
    for (j = 0; j < total[i]; ++j) {
      putchar('*');
    }
    putchar('\n');
  }

  return 0;
}
