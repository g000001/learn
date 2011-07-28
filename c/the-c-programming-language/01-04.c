/* celsius to fahrenheit */
#include <stdio.h>

main () {
  float cels, fahr;

  /* title */
  printf("celsius\tfahrenheit\n");

  cels = 0;
  while (cels <= 150) {
    fahr = 32 + (9.0 / 5.0 * cels);
    printf("%6.0f\t%8.1f\n", cels, fahr);
    cels = cels + 10;
  }
}
