#include <stdio.h>
#define LINE_SIZE 1000
#define TAB_SIZE 8

void detab(char[]);
void entab(char[]);
void clear(char[]);
void inc_pos(void);

int pos = 0;

void detab(char line[])
{
    int limit = TAB_SIZE - (pos % TAB_SIZE);
    extern int pos;

    int i = 0;
    for (; i < limit; ++i) {
      line[pos] = ' ';
      ++pos;
    }
}

void clear(char line[])
{
    extern int pos;

    int i = 0;
    for (; i < pos; ++i) {
      line[i] = '\0';
    }
    pos = 0;
}

void terminate_line(char line[]) {
  extern int pos;
  line[++pos] = '\0';
}

void inc_pos()
{
    extern int pos;
    ++pos;
}

void set_char(int c, char line[]) {
  line[pos] = c;
}

void entab(char line[])
{
  int i = 0;
  int p = 0;
  int cnt = 0;
  for (; line[i] != '\0'; ++i, ++p) {
    if ((p != 0) && ((p % TAB_SIZE) == 0) && (cnt != 0)) {
      putchar('\t');
      cnt = 0;
    }

    if (line[i] == ' ') {
      ++cnt;
    } else {
      if (p > 0) {
        int i = 0;
        for (; i < cnt; ++i) {
          putchar(' ');
        }
        cnt = 0;
      }
      putchar(line[i]);
    }
  }
}

int main()
{
    int c;
    char line[LINE_SIZE];

    while ((c = getchar()) != EOF) {
        if (c == '\t') {
          detab(line);
        } else {
          set_char(c, line);
          if (c == '\n') {
            terminate_line(line);
            entab(line);
            clear(line);
          } else {
            inc_pos();
          }
        }
    }
    return 0;
}

/*
   Q.次のタブストップまでスペース一つ分のとき、スペースとタブのどちらを利用すべきか

   A. 整合性が取れるのでタブの方が良いのでは?(自信なし)

*/
