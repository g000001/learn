/* reverse */
#include <stdio.h>
#define BUFFERLEN 1000

int mygetline(char[], int maxline);
int length(char s[]);
void reverse(char from[], char to[]);

int main()
{
    char line[BUFFERLEN];
    char rev[BUFFERLEN];
    int i;

    while (mygetline(line, BUFFERLEN) > 0) {
        reverse(line, rev);
        printf("%s", rev);
    }
    return 0;
}

int length(char s[])
{
    int i = 0;
    while (s[i] != '\0') {
        ++i;
    }
    return i;
}


void reverse(char from[], char to[])
{
    int e = length(from);
    to[e--] = '\0';
    if (from[e] == '\n') {
        to[e--] = '\n';
    }

    int i = 0;
    while (i <= e) {
        to[i] = from[e - i];
        ++i;
    }
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
