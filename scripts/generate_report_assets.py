#!/usr/bin/env python3
"""Genera gráficos y tablas para el informe en docs/assets/"""
import os, subprocess, json, csv, platform

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS = os.path.join(ROOT, "docs", "assets")
COMPILER = os.path.join(ROOT, "a.exe" if platform.system() == "Windows" else "a.out")
INPUTS = os.path.join(ROOT, "inputs")
BENCH_CSV = os.path.join(ROOT, "benchmarks", "results.csv")

os.makedirs(ASSETS, exist_ok=True)

def run_compiler(path, no_opt=False):
    cmd = [COMPILER, path, "--emit-json"]
    if no_opt:
        cmd.append("--no-opt")
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT)
    if r.returncode != 0:
        return None
    try:
        return json.loads(r.stdout)
    except json.JSONDecodeError:
        return None


def count_asm_lines(data):
    if not data or not data.get("assembly"):
        return 0
    return sum(1 for l in data["assembly"].split("\n") if l.strip() and not l.strip().startswith("."))


def collect_optimization_data():
    rows = []
    for i in range(1, 22):
        p = os.path.join(INPUTS, f"input{i}.txt")
        if not os.path.isfile(p):
            continue
        with_opt = run_compiler(p, no_opt=False)
        without = run_compiler(p, no_opt=True)
        if with_opt and without:
            s1 = with_opt.get("stats", {})
            lines_no = count_asm_lines(without)
            lines_opt = count_asm_lines(with_opt)
            saved = lines_no - lines_opt
            rows.append({
                "input": f"input{i}",
                "orig_no": lines_no,
                "orig_opt": lines_opt,
                "saved": saved,
                "dag": s1.get("dagHits", 0),
                "peep": s1.get("peepholeReductions", 0),
            })
    return rows


def write_optimization_md(rows):
    path = os.path.join(ASSETS, "tabla_optimizacion.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("# Tabla de optimización por input\n\n")
        f.write("| Input | Sin opt | Con opt | Ahorro | DAG | Peephole |\n")
        f.write("|---|---:|---:|---:|---:|---:|\n")
        total_saved = 0
        for r in rows:
            f.write(f"| {r['input']} | {r['orig_no']} | {r['orig_opt']} | {r['saved']} | {r['dag']} | {r['peep']} |\n")
            total_saved += r["saved"]
        f.write(f"\n**Total instrucciones ahorradas:** {total_saved}\n")
    print("OK", path)
    return path


def write_benchmark_md():
    path = os.path.join(ASSETS, "tabla_benchmark.md")
    if os.path.isfile(BENCH_CSV):
        with open(BENCH_CSV, encoding="utf-8") as f:
            reader = csv.DictReader(f)
            rows = list(reader)
    else:
        rows = []
    with open(path, "w", encoding="utf-8") as f:
        f.write("# Benchmark — Comparación comercial\n\n")
        f.write("| Programa | Nuestro (ms) | Rustc (ms) | GCC (ms) | Ratio rustc | Ratio gcc |\n")
        f.write("|---|---:|---:|---:|---:|---:|\n")
        for r in rows:
            rustc = r.get("rustc_ms") or "N/A"
            gcc = r.get("gcc_ms") or "N/A"
            f.write(
                f"| {r.get('program','')} | {r.get('ours_ms','')} | {rustc} | {gcc} "
                f"| {r.get('ratio_rustc','—')} | {r.get('ratio_gcc','—')} |\n"
            )
        f.write("\nEjecutar: `py -3 benchmarks/run_benchmark.py` (Windows) o `python benchmarks/run_benchmark.py`\n\n")
        f.write("### Por qué matrix/strings fallan en rustc\n\n")
        f.write("- **matrix**: nuestro dialecto usa `i32[3][3]`; Rust estándar exige `[[i32; 3]; 3]`.\n")
        f.write("- **strings**: asignamos literales directamente a `String`; rustc requiere `.to_string()`.\n")
        f.write("- GCC compila los equivalentes en C sin problemas (misma lógica).\n")
    print("OK", path)


def try_matplotlib_charts(opt_rows):
    try:
        import matplotlib.pyplot as plt
        import matplotlib
        matplotlib.use("Agg")
    except ImportError:
        write_svg_chart(opt_rows)
        return

    if not opt_rows:
        return

    names = [r["input"] for r in opt_rows[:10]]
    no_opt = [r["orig_no"] for r in opt_rows[:10]]
    with_opt = [r["orig_opt"] for r in opt_rows[:10]]

    fig, ax = plt.subplots(figsize=(10, 5))
    x = range(len(names))
    w = 0.35
    ax.bar([i - w/2 for i in x], no_opt, w, label="Sin optimización", color="#64748b")
    ax.bar([i + w/2 for i in x], with_opt, w, label="Con optimización", color="#f97316")
    ax.set_xticks(list(x))
    ax.set_xticklabels(names, rotation=45, ha="right")
    ax.set_ylabel("Instrucciones")
    ax.set_title("Optimización: instrucciones generadas (primeros 10 inputs)")
    ax.legend()
    fig.tight_layout()
    p1 = os.path.join(ASSETS, "grafico_optimizacion.png")
    fig.savefig(p1, dpi=150)
    plt.close()
    print("OK", p1)

    # Benchmark bar if csv exists
    if os.path.isfile(BENCH_CSV):
        with open(BENCH_CSV, encoding="utf-8") as f:
            rows = [r for r in csv.DictReader(f) if r.get("ours_ms")]
        if rows:
            fig2, ax2 = plt.subplots(figsize=(9, 4))
            progs = [r["program"].replace(".rs", "") for r in rows]
            x = range(len(progs))
            w = 0.25
            ours = [float(r["ours_ms"]) for r in rows]
            rustc = [float(r["rustc_ms"]) if r.get("rustc_ms") else 0 for r in rows]
            gcc = [float(r["gcc_ms"]) if r.get("gcc_ms") else 0 for r in rows]
            ax2.bar([i - w for i in x], ours, w, label="Nuestro", color="#2563eb")
            ax2.bar(list(x), [v or 0 for v in rustc], w, label="Rustc", color="#dc2626")
            ax2.bar([i + w for i in x], [v or 0 for v in gcc], w, label="GCC", color="#16a34a")
            ax2.set_xticks(list(x))
            ax2.set_xticklabels(progs)
            ax2.set_ylabel("ms")
            ax2.set_title("Tiempo de compilación — Comparación comercial")
            ax2.legend()
            fig2.tight_layout()
            p2 = os.path.join(ASSETS, "grafico_benchmark.png")
            fig2.savefig(p2, dpi=150)
            plt.close()
            print("OK", p2)


def write_svg_chart(rows):
    """Fallback SVG sin matplotlib."""
    if not rows:
        return
    path = os.path.join(ASSETS, "grafico_optimizacion.svg")
    subset = rows[:10]
    max_v = max(max(r["orig_no"], r["orig_opt"]) for r in subset) or 1
    bars = ""
    for i, r in enumerate(subset):
        x = 40 + i * 70
        h1 = int(120 * r["orig_no"] / max_v)
        h2 = int(120 * r["orig_opt"] / max_v)
        bars += f'<rect x="{x}" y="{140-h1}" width="25" height="{h1}" fill="#64748b"/>'
        bars += f'<rect x="{x+28}" y="{140-h2}" width="25" height="{h2}" fill="#f97316"/>'
        bars += f'<text x="{x+10}" y="155" font-size="8" fill="#ccc">{r["input"][-2:]}</text>'
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="800" height="200">
  <text x="10" y="20" fill="white" font-size="14">Optimización: gris=sin opt, naranja=con opt</text>
  {bars}
  <rect x="600" y="10" width="15" height="15" fill="#64748b"/><text x="620" y="22" fill="#ccc" font-size="11">Sin opt</text>
  <rect x="600" y="30" width="15" height="15" fill="#f97316"/><text x="620" y="42" fill="#ccc" font-size="11">Con opt</text>
</svg>'''
    with open(path, "w", encoding="utf-8") as f:
        f.write(svg)
    print("OK", path)


def write_demo_script():
    path = os.path.join(ASSETS, "GUIA_DEMO.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("""# Guía demo en vivo (5–7 min)

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
""")
    print("OK", path)


if __name__ == "__main__":
    print("Generando assets para informe...")
    opt = collect_optimization_data()
    write_optimization_md(opt)
    write_benchmark_md()
    try_matplotlib_charts(opt)
    write_demo_script()
    print("\nListo. Archivos en docs/assets/")
