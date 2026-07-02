#[no_mangle]
pub extern "C" fn matrix_kernel() -> i32 {
    let mut m = [[0i32; 3]; 3];
    let mut i = 0;
    while i < 3 {
        let mut j = 0;
        while j < 3 {
            m[i as usize][j as usize] = i + j;
            j += 1;
        }
        i += 1;
    }
    m[1][1]
}