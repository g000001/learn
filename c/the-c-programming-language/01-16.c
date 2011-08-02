#include <stdio.h>
#define MAXLINE 1000

int mygetline(char[], int maxline);
void copy(char to[], char from[]);

int main()
{
    int len;
    int max;
    char line[MAXLINE];
    char longest[MAXLINE];

    max = 0;
    while ((len = mygetline(line, MAXLINE)) > 0) {
        /* はみ出た長さを測定 */
        if (line[len - 1] != '\n') {
            int c;
            while ((c = getchar()) != EOF && c != '\n') {
                /* 改行も勘定する */
                if (c == '\n') {
                    ++len;
                }
                ++len;
            }
        }

        /* 記録更新 */
        if (len > max) {
            max = len;
            copy(longest, line);
        }
    }

    if (max > 0) {
        if (max < MAXLINE) {
            printf("%d: %s", max, longest);
        } else {
            printf("%d: %s...\n", max, longest);
        }
    }
    return 0;
}

int mylength(char s[])
{
    int cnt = 0;
    while (s[cnt] != '\0') {
        ++cnt;
    }
    return cnt;
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

void copy(char to[], char from[])
{
    int i;

    i = 0;
    while ((to[i] = from[i]) != '\0') {
        ++i;
    }

}
