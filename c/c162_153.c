/*
http://nojiriko.asia/prolog/c162_153.html

このディレクトリの索引
http://toro.2ch.net/test/read.cgi/tech/1357748713/153
#  [1] 授業単元：データ構造アルゴリズム 
#  [2] 問題文(含コード&リンク)：文字列から任意の文字を探索するプログラムを作成しなさい。 
#  
#  [3] 環境 
#  　[3.1] OS： (UNIX) 
#  　[3.2] コンパイラ名とバージョン： (gcc ) 
#  　[3.3] 言語： (C) 
#  [4] 期限： ([年1月19日まで] ) 
#  [5] その他の制限： なし 
#  よろしくおねがいします。


文字列から任意の文字を探索する(_文字列,_任意の文字) :-
        sub_atom(_文字列,_,1,_,_任意の文字).

*/

#include <stdio.h>

int len (char *str) {
  int len = 0;
  for (; *str++ != '\0'; len++)
    ;
  return len;
}

int string_equal (char* str1, char* str2) {
  while(*str1 != '\0') {
    if (*str1 != *str2) goto lose;
    ++str1, ++str2;
  }
  return 1;
 lose: return 0;
}

int search (char* item, char *str) {
  int pos = 0;
  while(*str != '\0') {
    if (string_equal(item, str)) goto win;
    ++pos;
    ++str;
  }
  return -1;
 win: return pos;
}

int main() {
  char item[] = "123";
  char str[] = "......1234";
  printf("%d\n", len(str));
  // printf("string= %s %s %d\n", "oo", "foo",string_equal("oo", "foo"));
  printf("%s => %s; ==> %d\n", item, str, search(item, str));
}
