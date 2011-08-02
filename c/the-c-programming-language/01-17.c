/* 80字より長い行のみ印字する */
#include <stdio.h>
#define BUFFERLEN 82            /* 80 + \n\0 */

int mygetline(char[], int maxline);

int main()
{
    int len;
    char line[BUFFERLEN];

    while ((len = mygetline(line, BUFFERLEN)) > 0) {
        if (len == BUFFERLEN - 1) {
            /* 80文字を出力 */
            printf("%s", line);
            if (line[len - 1] != '\n') {
                /* 末尾が\n\0でない場合は残りがあるので\nまで出力 */
                int c;
                while ((c = getchar()) != EOF && c != '\n') {
                    putchar(c);
                }
                putchar('\n');
            }
        }
    }
    return 0;
}

int mygetline(char s[], int lim)
{
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
        s[i] = c;
    }

    if (c == '\n') {
        s[i] = c;
        ++i;
    }

    s[i] = '\0';
    return i;
}
