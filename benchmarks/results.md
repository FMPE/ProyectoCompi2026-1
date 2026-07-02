# Benchmark — Comparación Comercial

| Programa | Nuestro (ms) | Rustc/LLVM (ms) | Rustc/Cranelift (ms) | GCC (ms) | Ratio rustc/ours | Ratio clif/ours | Ratio gcc/ours |
|---|---:|---:|---:|---:|---:|---:|---:|
| fibonacci.rs | 9.52116760017816 | 364.02824420001707 | 338.8326418000361 | 278.78409279965126 | 38.23 | 35.59 | 29.28 |
| matrix.rs | 8.682146399951307 | 347.6914102000592 | 329.9343881999448 | 249.49316760012152 | 40.05 | 38.0 | 28.74 |
| strings.rs | 8.687469599863107 | 349.9281857999449 | 328.37797360007244 | 248.36741859999165 | 40.28 | 37.8 | 28.59 |
| loop_sum.rs | 8.166346200050612 | 337.34539599990967 | 331.6847502002929 | 248.17112760010787 | 41.31 | 40.62 | 30.39 |

*Menor tiempo = mejor. Ratio > 1 indica que nuestro compilador es más rápido.*

**Backends de rustc:** *LLVM* es el backend por defecto (optimizador completo, compilación más lenta); *Cranelift* (cg_clif, nightly `-Zcodegen-backend=cranelift`) prioriza velocidad de compilación sobre calidad del código generado — es la comparación más justa de "velocidad de compilación" sobre la misma fuente `.rs`.

## Tamaño del código x86 generado (comparación justa: solo la función, sin I/O)

| Programa (función) | Nuestro | Rustc/LLVM (-O2) | Rustc/Cranelift | GCC (-O2) |
|---|---:|---:|---:|---:|
| fibonacci (`fib`) | 34 / 63 | 24 / 50 | 31 / 36 | 304 / 390 |
| matrix (`matrix_kernel`) | 86 / 113 | 2 / 15 | 59 / 64 | 3 / 32 |
| loop_sum (`loop_sum_kernel`) | 28 / 53 | 2 / 15 | 21 / 26 | 3 / 32 |

*Cada celda = **instrucciones de la función** / **líneas totales del `.s`**.* Las tres columnas comerciales usan **variantes puras** (`extern "C"` en Rust / función C, sin `main` ni `println!`/`printf`, `-O2`), por eso son comparables con nuestro output ya limpio. `strings` se omite por ser solo I/O.

**Observaciones:** a `-O2`, tanto LLVM como GCC pliegan `matrix_kernel`/`loop_sum_kernel` a una **constante** (constant folding total del bucle: `return 2` / `return 499500`) — optimización que nuestro compilador no realiza (emite el bucle completo). Cranelift, en cambio, **no** las pliega (optimiza poco, prioriza velocidad de compilación). En `fib` (recursivo, no plegable) el contraste se invierte: GCC **desenrolla y vectoriza** la recursión convertida en bucle, disparando su conteo de instrucciones muy por encima de LLVM y del nuestro — otro ejemplo de optimización comercial agresiva.

## Notas sobre rustc

- **matrix.rs**: Programa Rust estándar: [[0;3];3] e índices 'as usize'. Nuestro compilador ahora soporta el tipo usize y el cast 'as' (i32 -> usize), así que el mismo archivo compila tanto en nuestro compilador como en rustc.
- **strings.rs**: String = literal requiere .to_string() en Rust estándar

Los benchmarks usan la **misma lógica** en los cuatro programas; para rustc/GCC se usan archivos `.rs`/`.c` con sintaxis estándar donde aplica, o se reporta N/A cuando el dialecto del proyecto difiere de Rust oficial.
