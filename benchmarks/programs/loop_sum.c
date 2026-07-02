#include <stdio.h>
int main(void) {
    int s = 0;
    for (int i = 0; i < 1000; i++)
        s = s + i;
    printf("%d\n", s);
    return 0;
}