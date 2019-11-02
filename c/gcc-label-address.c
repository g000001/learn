//#include <stdio.h>

int
main ()
{
  void *tab[] = { &&L1, &&L2 };

  goto *tab[1];

 L1:
  return 0;
 L2:
  return 1;
}
