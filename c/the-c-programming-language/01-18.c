#include <stdio.h>
#define BUFFERLEN 1000

int mygetline(char[], int maxline);
int blank_char_p(int c);
int last_non_blank_char_pos(char line[]);

int main()
{
    char line[BUFFERLEN];
    int limit;
    int i;
    while (mygetline(line, BUFFERLEN) > 0) {
        if (limit = last_non_blank_char_pos(line)) {
            for (i = 0; (i < limit); ++i) {
                putchar(line[i]);
            }
            putchar('\n');
        }
    }
    return 0;
}

int non_blank_char_p(int c)
{
    return (c != ' ') && (c != '\t') && (c != '\n');
}

int last_non_blank_char_pos(char line[])
{
    int pos = 0;
    int last_non_blank_pos = 0;
    while (line[pos] != '\0') {
        if (non_blank_char_p(line[pos])) {
            ++last_non_blank_pos;
        }
        ++pos;
    }
    return last_non_blank_pos;
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
