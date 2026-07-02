#include <stdio.h>
int main(void) {
    int m[3][3];
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            m[i][j] = i + j;
    printf("%d\n", m[1][1]);
    return 0;
}