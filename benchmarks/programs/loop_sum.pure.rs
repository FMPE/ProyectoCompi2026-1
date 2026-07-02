#[no_mangle]
pub extern "C" fn loop_sum_kernel() -> i32 {
    let mut s = 0;
    for i in 0..1000 {
        s += i;
    }
    s
}