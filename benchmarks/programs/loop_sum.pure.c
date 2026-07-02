int loop_sum_kernel(void) {
    int s = 0;
    for (int i = 0; i < 1000; i++)
        s += i;
    return s;
}