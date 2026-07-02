int matrix_kernel(void) {
    int m[3][3];
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            m[i][j] = i + j;
    return m[1][1];
}