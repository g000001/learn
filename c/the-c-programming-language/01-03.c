#include <stdio.h>

main () {
  float fahr, cels;

  /* title */
  printf("fahrenheit\tcelsius\n");

  fahr = 0;
  while (fahr <= 300) {
    cels = (5.0 / 9.0) * (fahr - 32);
    printf("%8.0f\t%6.1f\n", fahr, cels);
    fahr = fahr + 20;
  }
}
