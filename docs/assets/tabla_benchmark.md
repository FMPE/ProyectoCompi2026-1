# Benchmark — Comparación comercial

| Programa | Nuestro (ms) | Rustc (ms) | GCC (ms) | Ratio rustc | Ratio gcc |
|---|---:|---:|---:|---:|---:|
| fibonacci.rs | 48.594800010323524 | 334.29934005253017 | 430.56396008469164 | 6.88 | 8.86 |
| matrix.rs | 44.86811999231577 | N/A | 346.24234000220895 |  | 7.72 |
| strings.rs | 46.77398004569113 | N/A | 344.2856800276786 |  | 7.36 |
| loop_sum.rs | 49.40773998387158 | 275.4698200151324 | 344.0264399629086 | 5.58 | 6.96 |

Ejecutar: `python benchmarks/run_benchmark.py`

### Por qué matrix/strings fallan en rustc

- **matrix**: nuestro dialecto usa `i32[3][3]`; Rust estándar exige `[[i32; 3]; 3]`.
- **strings**: asignamos literales directamente a `String`; rustc requiere `.to_string()`.
- GCC compila los equivalentes en C sin problemas (misma lógica).
