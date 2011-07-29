#include <stdio.h>

main ()
{
  float fahr, cels;

  /* title */
  printf("fahrenheit\tcelsius\n");

  for (fahr = 300; fahr >= 0; fahr = fahr - 20) {
    cels = (5.0 / 9.0) * (fahr - 32);
    printf("%8.0f\t%6.1f\n", fahr, cels);
  }
}
