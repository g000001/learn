#include <stdio.h>

float fahr2cels(int);
int main();

float fahr2cels(int d) {
  return (5.0 / 9.0) * (d - 32);
}

int
main () {
  /* title */
  printf("fahrenheit\tcelsius\n");

  int fahr = 0;
  for(; fahr <= 300; fahr = fahr + 20) {
    printf("%d\t%6.1f\n", fahr, fahr2cels(fahr));
  }
  return 0;
}
