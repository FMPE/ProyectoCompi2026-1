#!/usr/bin/env python3
"""Genera Informe.pdf actualizado con tablas, gráficos, screenshots y discusión."""
import csv
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS = os.path.join(ROOT, "docs", "assets")
BENCH_CSV = os.path.join(ROOT, "benchmarks", "results.csv")
OPT_MD = os.path.join(ASSETS, "tabla_optimizacion.md")
OUT_PDF = os.path.join(ROOT, "Informe.pdf")

FONT_PATH = os.path.join(os.environ.get("WINDIR", r"C:\Windows"), "Fonts", "arial.ttf")
FONT_BOLD = os.path.join(os.environ.get("WINDIR", r"C:\Windows"), "Fonts", "arialbd.ttf")


def ensure_fpdf():
    try:
        from fpdf import FPDF  # noqa: F401
    except ImportError:
        import subprocess
        subprocess.check_call([sys.executable, "-m", "pip", "install", "fpdf2", "-q"])


def load_benchmark_rows():
    if not os.path.isfile(BENCH_CSV):
        return []
    with open(BENCH_CSV, encoding="utf-8") as f:
        return list(csv.DictReader(f))


def load_opt_summary():
    if not os.path.isfile(OPT_MD):
        return 0, []
    rows = []
    total = 0
    with open(OPT_MD, encoding="utf-8") as f:
        for line in f:
            if line.startswith("| input"):
                parts = [p.strip() for p in line.split("|")[1:-1]]
                if len(parts) >= 4 and parts[0].startswith("input"):
                    try:
                        saved = int(parts[3])
                        total += saved
                        rows.append(parts)
                    except ValueError:
                        pass
            if "Total instrucciones ahorradas" in line:
                try:
                    total = int(line.split(":")[-1].strip())
                except ValueError:
                    pass
    return total, rows


class InformePDF:
    def __init__(self):
        ensure_fpdf()
        from fpdf import FPDF

        self.pdf = FPDF()
        self.pdf.set_auto_page_break(auto=True, margin=15)
        if os.path.isfile(FONT_PATH):
            self.pdf.add_font("Arial", "", FONT_PATH)
            self.pdf.add_font("Arial", "B", FONT_BOLD if os.path.isfile(FONT_BOLD) else FONT_PATH)
            self.font = "Arial"
        else:
            self.font = "Helvetica"

    def _font(self, style="", size=11):
        self.pdf.set_font(self.font, style, size)

    def add_title_page(self):
        self.pdf.add_page()
        self._font("B", 18)
        self.pdf.cell(0, 12, "Proyecto Final: Compilador de Rust a x86-64", ln=True, align="C")
        self._font("", 12)
        self.pdf.ln(4)
        self.pdf.cell(0, 8, "CS3402 - Compiladores | UTEC", ln=True, align="C")
        self.pdf.cell(0, 8, "Semestre: 2026-1", ln=True, align="C")
        self.pdf.ln(10)
        self._font("", 11)
        self.pdf.multi_cell(
            0, 6,
            "Informe técnico actualizado con aplicación integrada, benchmarks contra rustc/GCC, "
            "métricas de optimización y capturas del pipeline visual."
        )

    def add_section(self, title):
        self.pdf.ln(4)
        self._font("B", 13)
        self.pdf.cell(0, 8, title, ln=True)
        self._font("", 10)

    def add_paragraph(self, text):
        self._font("", 10)
        self.pdf.multi_cell(0, 5, text)
        self.pdf.ln(2)

    def add_table(self, headers, rows, col_widths=None):
        if not col_widths:
            w = 190 / len(headers)
            col_widths = [w] * len(headers)
        self._font("B", 9)
        for i, h in enumerate(headers):
            self.pdf.cell(col_widths[i], 7, h, border=1, align="C")
        self.pdf.ln()
        self._font("", 9)
        for row in rows:
            for i, cell in enumerate(row):
                txt = str(cell) if cell not in (None, "") else "N/A"
                if len(txt) > 22:
                    txt = txt[:19] + "..."
                self.pdf.cell(col_widths[i], 6, txt, border=1)
            self.pdf.ln()

    def add_image_if_exists(self, name, caption, w=180):
        path = os.path.join(ASSETS, name)
        if not os.path.isfile(path):
            self.add_paragraph(f"[Imagen pendiente: {name}]")
            return
        if self.pdf.get_y() > 200:
            self.pdf.add_page()
        self._font("B", 10)
        self.pdf.cell(0, 6, caption, ln=True)
        self.pdf.image(path, w=w)
        self.pdf.ln(4)

    def build(self):
        bench = load_benchmark_rows()
        opt_total, _ = load_opt_summary()

        self.add_title_page()

        self.pdf.add_page()
        self.add_section("1. Resumen")
        self.add_paragraph(
            "Se implementó un compilador para un subconjunto educativo de Rust que genera ensamblador "
            "x86-64 (AT&T, System V ABI). El pipeline incluye análisis léxico, sintáctico, semántico, "
            "generación de código y optimización (DAG + Peephole + constant folding). "
            "Se añadieron inferencia de tipos, strings, arreglos 2D y una aplicación web con seis pestañas "
            "que visualiza tokens, AST, assembly, simulación y estadísticas."
        )

        self.add_section("2. Arquitectura")
        self.add_paragraph(
            "Flujo: Código fuente → Scanner → Parser → AST → TypeChecker → GenCodeVisitor → "
            "Optimizer → archivo .s. La API expone --emit-json para la app Flask (puerto 5002)."
        )

        self.add_section("3. Características avanzadas implementadas")
        self.add_table(
            ["Característica", "Estado", "Ejemplo"],
            [
                ["Inferencia de tipos", "Sí", "let x = 5;"],
                ["Strings", "Sí", 'let s: String = "Hola";'],
                ["Arreglos 2D", "Sí", "let mut m: i32[2][3];"],
                ["Punteros / genéricos", "No", "Trabajo futuro"],
            ],
            [55, 25, 110],
        )

        self.add_section("4. Optimización")
        self.add_paragraph(
            f"Se midió la reducción de instrucciones assembly con y sin optimizador en 21 inputs. "
            f"Total de instrucciones ahorradas: {opt_total}. Las técnicas aplicadas son: "
            "eliminación de subexpresiones comunes (DAG), peephole (strength reduction, mov redundante) "
            "y constant folding."
        )
        self.add_image_if_exists("grafico_optimizacion.png", "Figura 1. Instrucciones con/sin optimización")

        self.pdf.add_page()
        self.add_section("5. Comparación comercial")
        self.add_paragraph(
            "Se comparó el tiempo de compilación (promedio de 5 ejecuciones) contra rustc y GCC. "
            "Para GCC se usaron programas equivalentes en C con la misma lógica. "
            "Nuestro compilador es más rápido en compilación porque implementa un subconjunto reducido "
            "sin backend LLVM ni borrow checker."
        )

        if bench:
            b_rows = []
            for r in bench:
                b_rows.append([
                    r.get("program", ""),
                    f"{float(r['ours_ms']):.1f}" if r.get("ours_ms") else "N/A",
                    f"{float(r['rustc_ms']):.1f}" if r.get("rustc_ms") else "N/A",
                    f"{float(r['gcc_ms']):.1f}" if r.get("gcc_ms") else "N/A",
                    r.get("ratio_rustc", "—"),
                    r.get("ratio_gcc", "—"),
                ])
            self.add_table(
                ["Programa", "Nuestro", "Rustc", "GCC", "Ratio R", "Ratio G"],
                b_rows,
                [38, 28, 28, 28, 24, 24],
            )

        self.add_image_if_exists("grafico_benchmark.png", "Figura 2. Tiempos de compilación (ms)")

        self.add_section("5.1 Por qué matrix y strings no compilan en rustc")
        self.add_paragraph(
            "Los benchmarks matrix.rs y strings.rs usan la sintaxis de nuestro dialecto educativo, "
            "no Rust estándar. Rustc rechaza matrix.rs porque escribimos let mut m: i32[3][3]; "
            "cuando Rust exige let mut m: [[i32; 3]; 3];. En strings.rs, asignar un literal "
            "directamente a String falla (rustc espera &str o .to_string()). "
            "Esto no indica un fallo de nuestro compilador: medimos rustc solo donde la sintaxis "
            "coincide (fibonacci, loop_sum). GCC compila los equivalentes en C para los cuatro casos."
        )

        self.pdf.add_page()
        self.add_section("6. Aplicación integrada (6 pestañas)")
        self.add_paragraph(
            "La app web en http://127.0.0.1:5002 permite compilar desde el navegador y recorrer "
            "Código → Tokens → AST → Assembly → Simulación → Salida & Stats."
        )
        for i, (fname, cap) in enumerate([
            ("screenshot_01_codigo.png", "Pestaña Código"),
            ("screenshot_02_tokens.png", "Pestaña Tokens"),
            ("screenshot_03_ast.png", "Pestaña AST"),
            ("screenshot_04_assembly.png", "Pestaña Assembly"),
            ("screenshot_05_simulacion.png", "Pestaña Simulación"),
            ("screenshot_06_stats.png", "Pestaña Salida y Stats"),
        ], 1):
            self.pdf.add_page()
            self.add_image_if_exists(fname, f"Figura {i+2}. {cap}", w=175)

        self.pdf.add_page()
        self.add_section("7. Conclusiones")
        self.add_paragraph(
            "El compilador cumple las fases requeridas y produce código x86-64 correcto en 21 inputs de prueba. "
            "La optimización reduce instrucciones de forma medible. Los benchmarks muestran tiempos de compilación "
            "significativamente menores que rustc y GCC en programas equivalentes, coherente con un compilador "
            "monolítico de propósito educativo. La aplicación web facilita la demostración en vivo del pipeline completo."
        )

        self.add_section("8. Referencias")
        self.add_paragraph(
            "Aho, Lam, Sethi & Ullman — Compilers: Principles, Techniques, and Tools (2nd ed.). "
            "The Rust Programming Language — doc.rust-lang.org. "
            "System V AMD64 ABI."
        )

        self.pdf.output(OUT_PDF)
        return OUT_PDF


def main():
    path = InformePDF().build()
    print(f"OK → {path}")


if __name__ == "__main__":
    main()
