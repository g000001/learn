int
main ()
{
  int cnt;
  for (cnt = 5; cnt > 0; cnt--) {
    write(1, "bar\n", 4);
  }
  return 0;
}
