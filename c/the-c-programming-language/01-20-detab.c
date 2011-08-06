#include <stdio.h>
#define TAB_SIZE 8

void detab(void);
void reset_pos(void);
void inc_pos(void);

int pos = 0;

void detab()
{
    int limit = TAB_SIZE - (pos % TAB_SIZE);
    extern int pos;

    int i = 0;
    for (; i < limit; ++i) {
        putchar(' ');
        ++pos;
    }
}

void reset_pos()
{
    extern int pos;

    pos = 0;
}

void inc_pos()
{
    extern int pos;

    ++pos;
}

int main()
{
    int c;

    while ((c = getchar()) != EOF) {
        if (c == '\t') {
            detab();
        } else {
            putchar(c);
            if (c == '\n') {
                reset_pos();
            } else {
                inc_pos();
            }
        }
    }
    return 0;
}

/*
  Q.
   記号パラメータにすべきか変数にすべきか
   そもそも記号パラメータ(symbolic parameter)ってなんだ
   →記号定数のことか?
   Ans.
   実行時に変化することもないので定数で良いのではないだろうか

 */
