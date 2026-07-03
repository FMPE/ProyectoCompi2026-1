# Estado actual vs. Rúbrica del Proyecto 2

## Lo que ya tienes (del informe pasado)

| Criterio | Estado |
|---|---|
| Diseño y Lexer | Implementado (scanner, tokens, maximal munch) |
| Sintaxis y AST | Implementado (parser recursivo descendente, AST, tabla de símbolos con scopes) |
| Análisis Semántico | Implementado (verificación de tipos, mutabilidad, declaración antes de uso) |
| Generación x86-64 | Implementado (AT&T syntax, System V ABI, structs, arrays) |
| Optimización (DAG + Peephole) | Implementado (CSE via DAG, strength reduction, mov redundante) |
| Reporte técnico | Existe (del semestre pasado 2025-2, necesita actualizarse) |

---

## Lo que falta para cumplir la rúbrica

### Características Avanzadas — 2 pts (probablemente en 0 ahora)

El enunciado exige explícitamente:

1. **Punteros y manejo de memoria** (`&T`, `*const T`, `Box<T>` o al menos referencias) — **no implementado**
2. **Tipos genéricos / templates** (`fn suma<T>(a: T, b: T) -> T`) — **no implementado**
3. **Inferencia de tipos** (`let x = 5;` sin anotación explícita `: i32`) — **no implementado** (actualmente el tipo es obligatorio)
4. **Arreglos multidimensionales** (`let m: i32[3][3]`) — **no implementado** (solo 1D)
5. **Funciones lambda / closures** (`let f = |x| x + 1;`) — **no implementado**
6. **Strings** como tipo básico — el enunciado los pide en básicas pero solo tienes `println!` con literales

### Comparación Comercial — 2 pts (en 0)

El enunciado pide comparar con **GCC, Clang/LLVM, MSVC, Rustc o mrustc** (precisamente el repo que tienes como referencia). Necesitas:
- Diseñar un conjunto de **benchmarks** (programas de prueba con distintas cargas)
- Compilar los mismos benchmarks con rustc/gcc
- Medir y comparar: tiempo de compilación, tamaño del binario, tiempo de ejecución
- Presentar tablas y gráficos con análisis

### Optimización — actualmente "Regular" a "Bueno" (3 pts posibles)

Tienes DAG + Peephole pero para alcanzar "Excelente" necesitas:
- **Métricas cuantitativas** demostrando la mejora (ej. "pasamos de 12 instrucciones a 8, reducción de 33%")
- Considerar añadir: **constant folding**, **dead code elimination**, o **loop invariant code motion**

### Reporte Técnico — necesita actualización

El informe de 2025-2 existe, pero para 2026-1 debe cubrir las nuevas características que implementes.

---

## Prioridad de trabajo recomendada

```
Alta prioridad (máximo impacto en puntos):
  1. Comparación comercial         → 2 pts seguros con esfuerzo moderado
  2. Inferencia de tipos básica    → parte de las 2 pts de avanzadas
  3. Strings básicas (literales)   → requisito de básicas

Media prioridad:
  4. Arreglos multidimensionales   → más puntos de avanzadas
  5. Métricas de optimización      → subir de "Bueno" a "Excelente" en optimización

Alta complejidad (si el tiempo lo permite):
  6. Punteros / referencias
  7. Genéricos simples
  8. Lambdas
```

---

## Resumen de puntos en riesgo

| Criterio | Pts posibles | Estimado actual | Brecha |
|---|---|---|---|
| Diseño y Lexer | 2 | ~2 | — |
| Sintaxis y AST | 2 | ~2 | — |
| Análisis Semántico | 1 | ~1 | — |
| Generación x86 | 3 | ~2.5 | ~0.5 |
| Características Avanzadas | 2 | **~0** | **2** |
| Optimización | 3 | ~2 | ~1 |
| **Comparación Comercial** | 2 | **0** | **2** |
| Reporte Técnico | 2 | 1 (desactualizado) | ~1 |
| Exposición | 3 | (depende de ti) | — |
| **Total** | **20** | **~10.5** | **~6.5** |
