#include <stdio.h>
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
int main(void) {
    int r = fib(10);
    printf("%d\n", r);
    return 0;
}