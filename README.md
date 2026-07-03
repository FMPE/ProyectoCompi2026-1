# Proyecto 2 — Compilador Rust → x86-64

**CS3402 Compiladores | UTEC | 2026-1**

Compilador completo para un subconjunto de Rust con generación de ensamblador x86-64 (AT&T, System V ABI), un conjunto de optimizaciones (constant folding en AST, orden Sethi-Ullman, eliminación de funciones muertas, CSE y peephole) y aplicación web integrada.

## Inicio rápido

```powershell
# 1. Compilar el compilador y copiarlo al simulador
python scripts/build.py

# 2. Ejecutar tests (21 programas)
python run_all_inputs.py

# 3. Levantar la aplicación web
cd simulador_completo/backend
pip install flask flask-cors
python server.py
# Abrir http://localhost:5002

# 4. Benchmark vs rustc
python benchmarks/run_benchmark.py
```

## Pipeline del compilador

```
Código fuente → Scanner → Parser → AST → Análisis semántico → Codegen x86 → Optimizador → .s
```

## Características del lenguaje

| Categoría | Features |
|---|---|
| Básicas | tipos primitivos, structs, funciones, if/while/for, arrays 1D, println |
| Avanzadas | **inferencia de tipos** (`let x = 5`), **strings** (`String`), **arrays 2D** (`i32[3][3]`) |
| Optimización | **constant folding (AST)**, **orden Sethi-Ullman**, **dead-function elimination**, CSE (a nivel de AST), peephole (strength reduction, comparación con 0, propagación de constantes) |

## Aplicación integrada (+3 pts)

La app web incluye los 5 componentes requeridos:

1. **Editor de código**
2. **Visualización de tokens** (lexer)
3. **Visualización del AST** (parser)
4. **Generación de assembly x86-64**
5. **Simulación y salida** con estadísticas de optimización

## Estructura del proyecto

```
├── main.cpp, scanner.*, parser.*, ast.*, visitor.*, optimizer.*, constfold.*
├── compiler_api.*     # API JSON para la app web
├── ast_json.*         # Exportación AST → JSON
├── inputs/            # 21 casos de prueba
├── simulador_completo/backend/  # Flask + React
├── benchmarks/        # Comparación comercial vs rustc
├── scripts/build.py   # Build reproducible
└── docs/ARQUITECTURA.md
```

## CLI

```
compiler archivo.txt [--no-opt] [--stats] [--emit-json]
```

