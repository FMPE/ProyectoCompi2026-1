# Benchmark — Comparación Comercial

| Programa | Nuestro (ms) | Rustc/LLVM (ms) | Rustc/Cranelift (ms) | GCC (ms) | Ratio rustc/ours | Ratio clif/ours | Ratio gcc/ours |
|---|---:|---:|---:|---:|---:|---:|---:|
| fibonacci.rs | 10.405179400004272 | 509.47426979996635 | 530.6633675999819 | 294.02561540000534 | 48.96 | 51.0 | 28.26 |
| matrix.rs | 13.208693399997173 | 433.20703799997773 | 397.90259859996695 | 254.62040120000896 | 32.8 | 30.12 | 19.28 |
| strings.rs | 12.55199839999932 | 430.6539304000353 | 383.1090866000068 | 252.24586580000053 | 34.31 | 30.52 | 20.1 |
| loop_sum.rs | 10.858235000000604 | 425.4339025999798 | 432.058219999999 | 269.39180540000507 | 39.18 | 39.79 | 24.81 |

*Menor tiempo = mejor. Ratio > 1 indica que nuestro compilador es más rápido.*

**Backends de rustc:** *LLVM* es el backend por defecto (optimizador completo, compilación más lenta); *Cranelift* (cg_clif, nightly `-Zcodegen-backend=cranelift`) prioriza velocidad de compilación sobre calidad del código generado — es la comparación más justa de "velocidad de compilación" sobre la misma fuente `.rs`.

## Tamaño del código x86 generado (comparación justa: solo la función, sin I/O)

| Programa (función) | Nuestro | Rustc/LLVM (-O2) | Rustc/Cranelift | GCC (-O2) |
|---|---:|---:|---:|---:|
| fibonacci (`fib`) | 33 / 62 | 24 / 50 | 31 / 36 | 304 / 390 |
| matrix (`matrix_kernel`) | 83 / 110 | 2 / 15 | 59 / 64 | 3 / 32 |
| loop_sum (`loop_sum_kernel`) | 27 / 52 | 2 / 15 | 21 / 26 | 3 / 32 |

*Cada celda = **instrucciones de la función** / **líneas totales del `.s`**.* Las tres columnas comerciales usan **variantes puras** (`extern "C"` en Rust / función C, sin `main` ni `println!`/`printf`, `-O2`), por eso son comparables con nuestro output ya limpio. `strings` se omite por ser solo I/O.

**Observaciones:** a `-O2`, tanto LLVM como GCC pliegan `matrix_kernel`/`loop_sum_kernel` a una **constante** (constant folding total del bucle: `return 2` / `return 499500`) — optimización que nuestro compilador no realiza (emite el bucle completo). Cranelift, en cambio, **no** las pliega (optimiza poco, prioriza velocidad de compilación). En `fib` (recursivo, no plegable) el contraste se invierte: GCC **desenrolla y vectoriza** la recursión convertida en bucle, disparando su conteo de instrucciones muy por encima de LLVM y del nuestro — otro ejemplo de optimización comercial agresiva.

## Notas sobre rustc

- **matrix.rs**: Programa Rust estándar: [[0;3];3] e índices 'as usize'. Nuestro compilador ahora soporta el tipo usize y el cast 'as' (i32 -> usize), así que el mismo archivo compila tanto en nuestro compilador como en rustc.
- **strings.rs**: String = literal requiere .to_string() en Rust estándar

Los benchmarks usan la **misma lógica** en los cuatro programas; para rustc/GCC se usan archivos `.rs`/`.c` con sintaxis estándar donde aplica, o se reporta N/A cuando el dialecto del proyecto difiere de Rust oficial.
