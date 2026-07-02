fn matrix_kernel() -> i32 {
    let mut m = [[0;3];3];
    let mut i: i32 = 0;
    while i < 3 {
        let mut j: i32 = 0;
        while j < 3 {
            m[i as usize][j as usize] = i + j;
            j = j + 1;
        }
        i = i + 1;
    }
    return m[1 as usize][1 as usize];
}
fn main() {
    println!("{}", matrix_kernel());
}