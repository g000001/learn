int bar(int x)
{
  switch (x)
    {
    case '0':  case '1':  case '2':  case '3':  case '4':
    case '5':  case '6':  case '7':  case '8':  case '9':
    case 'A':  case 'B':  case 'C':  case 'D':  case 'E':
    case 'F':
      return 1;
    }
  return 0;
}


int
main ()
{
  bar('Z');
}
