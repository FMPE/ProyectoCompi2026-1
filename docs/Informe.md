# Informe Técnico — Compilador Rust → x86-64

**CS3402 Compiladores | UTEC | Semestre 2026-1**

> PDF generado: `Informe.pdf` — regenerar con `py -3 scripts/generate_informe.py`

## 1. Resumen

Compilador educativo para un subconjunto de Rust que genera ensamblador x86-64 (AT&T, System V ABI). Pipeline: Scanner → Parser → AST → TypeChecker → GenCode → Optimizer. Incluye app web con 6 pestañas (http://127.0.0.1:5002).

## 2. Características avanzadas

| Característica | Estado |
|---|---|
| Inferencia de tipos (`let x = 5`) | ✅ |
| Strings (`let s: String = "..."`) | ✅ |
| Arreglos 2D (`i32[2][3]`) | ✅ |
| Punteros / genéricos | ❌ (futuro) |

## 3. Optimización

Ver `docs/assets/tabla_optimizacion.md` y `docs/assets/grafico_optimizacion.png`.

Técnicas: DAG (CSE), Peephole (strength reduction), constant folding.

## 4. Comparación comercial

Ver `benchmarks/results.md`, `docs/assets/tabla_benchmark.md` y `docs/assets/grafico_benchmark.png`.

### Por qué matrix/strings no compilan en rustc

Nuestro dialecto **no es Rust estándar**:

- **matrix**: usamos `let mut m: i32[3][3];` — rustc exige `[[i32; 3]; 3]`.
- **strings**: `let s: String = "literal";` — rustc exige `.to_string()` o `&str`.

GCC compila los **equivalentes en C** (`benchmarks/programs/*.c`) para los cuatro benchmarks.

## 5. App integrada

Screenshots en `docs/assets/screenshot_0*.png` (6 pestañas).

## 6. Regenerar todo el informe

```powershell
cd c:\Users\Milton\Compilers\Proyecto2
$env:Path = "C:\msys64\ucrt64\bin;$env:USERPROFILE\.cargo\bin;" + $env:Path

# Terminal 1: servidor web
cd simulador_completo\backend
py -3 server.py

# Terminal 2: assets + PDF
py -3 benchmarks/run_benchmark.py
py -3 scripts/generate_report_assets.py
py -3 scripts/capture_screenshots.py
py -3 scripts/generate_informe.py
```
