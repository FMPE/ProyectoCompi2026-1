fn loop_sum_kernel() -> i32 {
    let mut s: i32 = 0;
    for i in 0..1000 {
        s = s + i;
    }
    return s;
}
fn main() {
    println!("{}", loop_sum_kernel());
}