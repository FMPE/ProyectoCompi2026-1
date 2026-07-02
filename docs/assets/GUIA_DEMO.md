# Guía demo en vivo (5–7 min)

## Preparación
```powershell
python scripts/build.py
cd simulador_completo/backend
python server.py
```
Abrir: **http://127.0.0.1:5002** (Ctrl+F5 para recargar sin caché)

## Guión

1. **Pestaña Código** — Mostrar programa con inferencia, strings y array 2D.
2. Clic **Compilar** → salta a **Tokens**: explicar lexer (FN, LET, IDENTIFIER...).
3. **AST** — Mostrar árbol Program → Function → Block → Let/Println.
4. **Assembly** — Código x86 generado (.data, .text, printf).
5. **Simulación** — Run paso a paso, ver registros %rax, %rsi.
6. **Salida & Stats** — Mostrar salida 15 y "Hola compilador", barra de reducción %.

## Screenshots para informe
Tomar captura de cada pestaña después de compilar:
- `docs/assets/screenshot_01_codigo.png`
- `docs/assets/screenshot_02_tokens.png`
- `docs/assets/screenshot_03_ast.png`
- `docs/assets/screenshot_04_assembly.png`
- `docs/assets/screenshot_05_simulacion.png`
- `docs/assets/screenshot_06_stats.png`

Usar Win+Shift+S en Windows.

## Insertar en Informe.pdf
- Tabla benchmark: `docs/assets/tabla_benchmark.md`
- Tabla optimización: `docs/assets/tabla_optimizacion.md`
- Gráficos: `grafico_optimizacion.png` y `grafico_benchmark.png`
