#!/usr/bin/env python3
"""
Benchmark: compara tiempo de compilación de nuestro compilador vs rustc y GCC.
Genera benchmarks/results.csv y benchmarks/results.md
"""
import os
import re
import shutil
import subprocess
import time
import platform
import csv

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH_DIR = os.path.join(ROOT, "benchmarks", "programs")
OUT_DIR = os.path.join(ROOT, "benchmarks")
OUTPUTS_DIR = os.path.join(ROOT, "benchmarks", "Outputs")  # x86 generado por cada compilador
COMPILER = os.path.join(ROOT, "a.exe" if platform.system() == "Windows" else "a.out")

PROGRAMS = {
    "fibonacci": {
        "ours": """fn fib(n: i32) -> i32 {
    if n <= 1 { return n; }
    return fib(n - 1) + fib(n - 2);
}
fn main() {
    let mut r: i32 = fib(10);
    println!("{}", r);
}""",
        "c": """#include <stdio.h>
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}
int main(void) {
    int r = fib(10);
    printf("%d\\n", r);
    return 0;
}""",
        "rs_pure": """#[no_mangle]
pub extern "C" fn fib(n: i32) -> i32 {
    if n <= 1 { return n; }
    fib(n - 1) + fib(n - 2)
}""",
        "c_pure": """int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}""",
    },
    "matrix": {
        "ours": """fn matrix_kernel() -> i32 {
    let mut m = [[0;3];3];
    let mut i: i32 = 0;
    while i < 3 {
        let mut j: i32 = 0;
        while j < 3 {
            m[i as usize][j as usize] = i + j;
            j = j + 1;
        }
        i = i + 1;
    }
    return m[1 as usize][1 as usize];
}
fn main() {
    println!("{}", matrix_kernel());
}""",
        "c": """#include <stdio.h>
int main(void) {
    int m[3][3];
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            m[i][j] = i + j;
    printf("%d\\n", m[1][1]);
    return 0;
}""",
        "rs_pure": """#[no_mangle]
pub extern "C" fn matrix_kernel() -> i32 {
    let mut m = [[0i32; 3]; 3];
    let mut i = 0;
    while i < 3 {
        let mut j = 0;
        while j < 3 {
            m[i as usize][j as usize] = i + j;
            j += 1;
        }
        i += 1;
    }
    m[1][1]
}""",
        "c_pure": """int matrix_kernel(void) {
    int m[3][3];
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            m[i][j] = i + j;
    return m[1][1];
}""",
    },
    "strings": {
        "ours": """fn main() {
    let s = "Benchmark OK";
    let x = 42;
    println!("{}", x);
    println!("{}", s);
}""",
        "c": """#include <stdio.h>
int main(void) {
    const char *s = "Benchmark OK";
    int x = 42;
    printf("%d\\n", x);
    printf("%s\\n", s);
    return 0;
}""",
    },
    "loop_sum": {
        "ours": """fn loop_sum_kernel() -> i32 {
    let mut s: i32 = 0;
    for i in 0..1000 {
        s = s + i;
    }
    return s;
}
fn main() {
    println!("{}", loop_sum_kernel());
}""",
        "c": """#include <stdio.h>
int main(void) {
    int s = 0;
    for (int i = 0; i < 1000; i++)
        s = s + i;
    printf("%d\\n", s);
    return 0;
}""",
        "rs_pure": """#[no_mangle]
pub extern "C" fn loop_sum_kernel() -> i32 {
    let mut s = 0;
    for i in 0..1000 {
        s += i;
    }
    s
}""",
        "c_pure": """int loop_sum_kernel(void) {
    int s = 0;
    for (int i = 0; i < 1000; i++)
        s += i;
    return s;
}""",
    },
}

# Símbolo (función) objetivo por programa para el conteo de líneas x86.
# Los programas solo de I/O (p. ej. strings) no aparecen y se excluyen del cuadro.
KERNEL = {
    "fibonacci": "fib",
    "matrix": "matrix_kernel",
    "loop_sum": "loop_sum_kernel",
}

RUSTC_NOTES = {
    "matrix": "Programa Rust estándar: [[0;3];3] e índices 'as usize'. Nuestro compilador "
              "ahora soporta el tipo usize y el cast 'as' (i32 -> usize), así que el mismo "
              "archivo compila tanto en nuestro compilador como en rustc.",
    "strings": "String = literal requiere .to_string() en Rust estándar",
}


def ensure_programs():
    os.makedirs(BENCH_DIR, exist_ok=True)
    for name, src in PROGRAMS.items():
        txt_path = os.path.join(BENCH_DIR, f"{name}.txt")
        rs_path = os.path.join(BENCH_DIR, f"{name}.rs")
        c_path = os.path.join(BENCH_DIR, f"{name}.c")
        with open(txt_path, "w", encoding="utf-8") as f:
            f.write(src["ours"])
        with open(rs_path, "w", encoding="utf-8") as f:
            f.write(src["ours"])
        with open(c_path, "w", encoding="utf-8") as f:
            f.write(src["c"])
        # Variantes "puras" (solo la función, sin main ni I/O) para la
        # comparación justa de código x86; solo si el programa las define.
        if "rs_pure" in src:
            with open(os.path.join(BENCH_DIR, f"{name}.pure.rs"), "w", encoding="utf-8") as f:
                f.write(src["rs_pure"])
        if "c_pure" in src:
            with open(os.path.join(BENCH_DIR, f"{name}.pure.c"), "w", encoding="utf-8") as f:
                f.write(src["c_pure"])


def bench_compiler(path, runs=5):
    if not os.path.isfile(COMPILER):
        return None
    times = []
    for _ in range(runs):
        t0 = time.perf_counter()
        r = subprocess.run([COMPILER, path], capture_output=True, text=True, cwd=ROOT)
        times.append(time.perf_counter() - t0)
        if r.returncode != 0:
            return None
    return sum(times) / len(times) * 1000


def bench_rustc(path, runs=5):
    try:
        subprocess.run(["rustc", "--version"], capture_output=True, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    times = []
    out = path + ".rustc.out"
    for _ in range(runs):
        t0 = time.perf_counter()
        r = subprocess.run(["rustc", path, "-o", out], capture_output=True, text=True)
        times.append(time.perf_counter() - t0)
        if r.returncode != 0:
            return None
    if os.path.isfile(out):
        os.remove(out)
    return sum(times) / len(times) * 1000


def bench_gcc(path, runs=5):
    try:
        subprocess.run(["gcc", "--version"], capture_output=True, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    times = []
    out = path + ".gcc.out"
    for _ in range(runs):
        t0 = time.perf_counter()
        r = subprocess.run(["gcc", path, "-O2", "-o", out], capture_output=True, text=True)
        times.append(time.perf_counter() - t0)
        if r.returncode != 0:
            return None
    if os.path.isfile(out):
        os.remove(out)
    return sum(times) / len(times) * 1000


_NIGHTLY_CACHE = "__unset__"


def find_nightly_toolchain():
    """Devuelve el nombre exacto de un toolchain nightly instalado, o None.

    `rustc +nightly` resuelve a nightly-<default-host>, que en máquinas MSVC
    apunta a un toolchain no instalado; por eso usamos el nombre completo
    (p. ej. nightly-x86_64-pc-windows-gnu).
    """
    global _NIGHTLY_CACHE
    if _NIGHTLY_CACHE != "__unset__":
        return _NIGHTLY_CACHE
    _NIGHTLY_CACHE = None
    try:
        r = subprocess.run(["rustup", "toolchain", "list"],
                           capture_output=True, text=True, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    for line in r.stdout.splitlines():
        name = line.split()[0] if line.split() else ""
        if name.startswith("nightly"):
            _NIGHTLY_CACHE = name
            break
    return _NIGHTLY_CACHE


def bench_rustc_clif(path, runs=5):
    """rustc con backend Cranelift (cg_clif): codegen rápido, sin LLVM."""
    toolchain = find_nightly_toolchain()
    if not toolchain:
        return None
    out = path + ".clif.out"
    cmd = ["rustc", "+" + toolchain, "-Zcodegen-backend=cranelift", path, "-o", out]
    times = []
    for _ in range(runs):
        t0 = time.perf_counter()
        r = subprocess.run(cmd, capture_output=True, text=True)
        times.append(time.perf_counter() - t0)
        if r.returncode != 0:
            return None
    if os.path.isfile(out):
        os.remove(out)
    return sum(times) / len(times) * 1000


def filter_objdump_user_code(dump, crate_name):
    """Conserva solo los bloques de funciones del usuario en una salida de objdump.

    objdump -d desensambla el binario completo (incluida toda la stdlib de Rust
    enlazada estáticamente, ~8 MB). Nos quedamos con `main` y las funciones cuyo
    símbolo mangled contiene el nombre de la crate (fib, etc.).
    """
    header_re = re.compile(r"^[0-9a-fA-F]+ <(.+)>:$")
    blocks = []
    current = []
    keep = False
    for line in dump.splitlines():
        m = header_re.match(line)
        if m:
            if keep and current:
                blocks.append("\n".join(current))
            sym = m.group(1)
            keep = (sym == "main") or (crate_name in sym)
            current = [line] if keep else []
        elif keep:
            current.append(line)
    if keep and current:
        blocks.append("\n".join(current))
    return "\n\n".join(blocks)


IS_LINUX = platform.system() != "Windows"


def win_to_wsl_path(winpath):
    """Convierte una ruta Windows (D:\\...) a su equivalente WSL (/mnt/d/...)."""
    p = winpath.replace("\\", "/")
    p = re.sub(r"^([A-Za-z]):", lambda m: "/mnt/" + m.group(1).lower(), p)
    return p


def lin(path):
    """Ruta usable por las herramientas Linux/gas.

    Si el script ya corre dentro de WSL, se usa tal cual; si corre en Windows,
    se traduce a /mnt/<letra>/...
    """
    return path if IS_LINUX else win_to_wsl_path(path)


def run_linux(cmd_str):
    """Ejecuta un comando de shell en el entorno Linux (WSL).

    Funciona corriendo el script desde Windows (envuelve en `wsl`) o desde
    dentro de WSL (llama a `bash` directo; envolver en `wsl` fallaría porque
    `wsl` no está en el PATH de la distro). Devuelve el CompletedProcess, o
    None si la herramienta no existe.
    """
    argv = ["bash", "-lc", cmd_str] if IS_LINUX else ["wsl", "bash", "-lc", cmd_str]
    try:
        return subprocess.run(argv, capture_output=True, text=True)
    except FileNotFoundError:
        return None


def save_assembly(name, txt_path, rs_path, c_path):
    """Genera y guarda el x86-64 de cada compilador en benchmarks/Outputs/.

    Paso aparte del cronometrado (no afecta los tiempos). Cada backend se
    intenta de forma independiente: si falta una herramienta, se omite ese
    archivo sin abortar el resto.

    rustc-llvm y gcc usan el compilador de WSL para emitir ensamblador
    Linux/ELF (ensamblable con gas en WSL). El compilador nativo de Windows
    emitiría COFF/PE, que gas no reconoce.
    """
    os.makedirs(OUTPUTS_DIR, exist_ok=True)

    # 1. Nuestro compilador: emite "<base>.s" junto a la fuente .txt
    if os.path.isfile(COMPILER):
        try:
            r = subprocess.run([COMPILER, txt_path], capture_output=True, text=True, cwd=ROOT)
            produced = os.path.splitext(txt_path)[0] + ".s"
            if r.returncode == 0 and os.path.isfile(produced):
                shutil.copyfile(produced, os.path.join(OUTPUTS_DIR, f"{name}.ours.s"))
                os.remove(produced)  # no dejar el .s en programs/
        except OSError:
            pass

    # 2. rustc / LLVM en Linux: --emit=asm produce ELF ensamblable.
    #    El rustc de Windows emitiría COFF, que gas no acepta.
    cmd = (f"source ~/.cargo/env && rustc --emit=asm -C opt-level=0 "
           f"'{lin(rs_path)}' -o '{lin(os.path.join(OUTPUTS_DIR, f'{name}.rustc-llvm.s'))}'")
    run_linux(cmd)

    # 3. rustc / Cranelift: cg_clif NO soporta --emit=asm (genera código máquina
    #    directo), así que compilamos a binario y lo desensamblamos con objdump.
    #    Se usa el rustc de Windows (nightly + cg_clif instalado allí).
    toolchain = find_nightly_toolchain()
    if toolchain:
        exe = os.path.join(OUTPUTS_DIR, f"{name}.rustc-cranelift.exe")
        try:
            r = subprocess.run(["rustc", "+" + toolchain, "-Zcodegen-backend=cranelift",
                                rs_path, "-o", exe], capture_output=True, text=True)
            if r.returncode == 0 and os.path.isfile(exe):
                dis = subprocess.run(["objdump", "-d", "--no-show-raw-insn", exe],
                                     capture_output=True, text=True)
                if dis.returncode == 0:
                    asm_path = os.path.join(OUTPUTS_DIR, f"{name}.rustc-cranelift.s")
                    user_code = filter_objdump_user_code(dis.stdout, name)
                    with open(asm_path, "w", encoding="utf-8") as f:
                        f.write("# Desensamblado (objdump -d) del binario de Cranelift, filtrado\n")
                        f.write("# a las funciones del usuario (main + crate). cg_clif genera\n")
                        f.write("# codigo maquina directo; no soporta --emit=asm.\n\n")
                        f.write(user_code if user_code.strip() else dis.stdout)
        except (FileNotFoundError, OSError):
            pass
        finally:
            if os.path.isfile(exe):
                os.remove(exe)

    # 4. gcc en Linux: -S produce ensamblador Linux/ELF ensamblable con gas.
    #    El gcc de Windows (MinGW) emitiría COFF.
    cmd = f"gcc -S -O2 '{lin(c_path)}' -o '{lin(os.path.join(OUTPUTS_DIR, f'{name}.gcc.s'))}'"
    run_linux(cmd)

    # ----------------------------------------------------------------------
    # Variantes PURAS (solo la función, sin main ni I/O) para comparación justa
    # de código x86. Todas via WSL, a -O2. Solo si el programa las define.
    # ----------------------------------------------------------------------
    save_pure_assembly(name)


def objdump_block(text, func):
    """Extrae el bloque desensamblado de la función `func` de una salida objdump.

    Un staticlib `.a` de rustc empaqueta también `core`/`compiler_builtins`, así
    que objdump desensambla todo el archivo (~8 MB). Nos quedamos solo con el
    bloque cuya cabecera es `<func>:` (símbolo no_mangle), hasta la línea en
    blanco o la siguiente cabecera.
    """
    lines = text.splitlines()
    for idx, ln in enumerate(lines):
        if ln.strip().endswith(f"<{func}>:"):
            block = [ln]
            for nxt in lines[idx + 1:]:
                s = nxt.strip()
                if not s or (s.endswith(":") and "<" in s and ">" in s):
                    break
                block.append(nxt)
            return "\n".join(block)
    return ""


def save_pure_assembly(name):
    """Genera el x86 de la variante pura (función-núcleo, sin I/O) por compilador.

    Produce, cuando la fuente existe: {name}.rustc-llvm-pure.s,
    {name}.rustc-cranelift-pure.s y {name}.gcc-pure.s. Como la función es
    `#[no_mangle]` / C plano, el símbolo queda sin manglear y el .s no arrastra
    libstd ni `main`.
    """
    pure_rs = os.path.join(BENCH_DIR, f"{name}.pure.rs")
    pure_c  = os.path.join(BENCH_DIR, f"{name}.pure.c")
    func    = KERNEL.get(name, "")
    # El nombre de crate se infiere del archivo; "{name}.pure" tiene un punto
    # inválido, así que lo pasamos explícito y saneado.
    crate = f"{name}_pure".replace("-", "_")

    # a. rustc / LLVM puro: --emit=asm sobre un staticlib -> solo la función.
    if os.path.isfile(pure_rs):
        cmd = (f"source ~/.cargo/env && rustc --emit=asm -C opt-level=2 "
               f"--crate-type=staticlib --crate-name {crate} -C panic=abort "
               f"'{lin(pure_rs)}' -o '{lin(os.path.join(OUTPUTS_DIR, f'{name}.rustc-llvm-pure.s'))}'")
        run_linux(cmd)

    # b. rustc / Cranelift puro: cg_clif no soporta --emit=asm; compilamos el
    #    staticlib y lo desensamblamos con objdump. El símbolo no_mangle hace
    #    innecesario filtrar libstd.
    toolchain = find_nightly_toolchain()
    if os.path.isfile(pure_rs) and toolchain:
        lib_out  = os.path.join(OUTPUTS_DIR, f"{name}.pure.a")
        asm_path = os.path.join(OUTPUTS_DIR, f"{name}.rustc-cranelift-pure.s")
        cmd = (f"source ~/.cargo/env && "
               f"rustc +{toolchain} -Zcodegen-backend=cranelift "
               f"--crate-type=staticlib --crate-name {crate} -C panic=abort -C opt-level=2 "
               f"'{lin(pure_rs)}' -o '{lin(lib_out)}' "
               f"&& objdump -d --no-show-raw-insn -C '{lin(lib_out)}'")
        r = run_linux(cmd)
        try:
            if r and r.returncode == 0 and r.stdout.strip():
                block = objdump_block(r.stdout, func) or r.stdout
                with open(asm_path, "w", encoding="utf-8") as f:
                    f.write("# Desensamblado (objdump -d) del staticlib de Cranelift, filtrado a la\n")
                    f.write(f"# funcion pura '{func}' (no_mangle). cg_clif genera codigo maquina\n")
                    f.write("# directo; no soporta --emit=asm.\n\n")
                    f.write(block)
                    f.write("\n")
        finally:
            if os.path.isfile(lib_out):
                os.remove(lib_out)

    # c. gcc puro: -S sobre la función C, sin main.
    if os.path.isfile(pure_c):
        cmd = (f"gcc -S -O2 '{lin(pure_c)}' "
               f"-o '{lin(os.path.join(OUTPUTS_DIR, f'{name}.gcc-pure.s'))}'")
        run_linux(cmd)


def _count_func_instructions(lines, func):
    """Cuenta las instrucciones x86 dentro del bloque de la función `func`.

    Soporta dos formatos: fuente AT&T/GAS (label `func:` a columna 0) y
    desensamblado de objdump (cabecera `... <func>:`). Devuelve None si la
    función no aparece.
    """
    # Formato objdump: cabecera "0000... <func>:"
    header = None
    for idx, ln in enumerate(lines):
        if ln.strip().endswith(f"<{func}>:"):
            header = idx
            break
    if header is not None:
        n = 0
        for ln in lines[header + 1:]:
            s = ln.strip()
            if not s:
                break                      # fin del bloque (línea en blanco)
            if s.endswith(":") and "<" in s and ">" in s:
                break                      # siguiente cabecera de función
            if re.match(r"^[0-9a-fA-F]+:", s):
                n += 1                     # línea de instrucción: "  0:\tpush ..."
        return n

    # Formato fuente (GAS/AT&T): label "func:" a columna 0
    start = None
    for idx, ln in enumerate(lines):
        if ln.strip() == f"{func}:":
            start = idx
            break
    if start is None:
        return None
    n = 0
    for ln in lines[start + 1:]:
        s = ln.strip()
        if not s or s.startswith("#") or s.startswith("//"):
            continue
        if s.startswith("."):
            continue                       # directiva (.cfi, .size, .globl, .L*, .section)
        if s.endswith(":"):
            break                          # siguiente función (label no-.L a columna 0)
        n += 1
    return n


def count_asm(path, func):
    """Devuelve (instrucciones_de_func, lineas_totales) del .s, o (None, None)."""
    if not path or not os.path.isfile(path):
        return (None, None)
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            lines = f.read().splitlines()
    except OSError:
        return (None, None)
    return (_count_func_instructions(lines, func), len(lines))


def _fmt_count(instr, total):
    """Formatea una celda 'instr / total' con N/A donde falte el dato."""
    i = str(instr) if instr is not None else "N/A"
    t = str(total) if total is not None else "N/A"
    if instr is None and total is None:
        return "N/A"
    return f"{i} / {t}"


def asm_line_counts():
    """Cuenta instrucciones/total del x86 puro por compilador para cada kernel.

    Devuelve lista de dicts: {program, func, ours, llvm, clif, gcc} con cada
    valor en formato 'instr / total'. Solo programas en KERNEL (con núcleo
    algorítmico); `strings` (solo I/O) se omite.
    """
    rows = []
    for name, func in KERNEL.items():
        sources = {
            "ours": os.path.join(OUTPUTS_DIR, f"{name}.ours.s"),
            "llvm": os.path.join(OUTPUTS_DIR, f"{name}.rustc-llvm-pure.s"),
            "clif": os.path.join(OUTPUTS_DIR, f"{name}.rustc-cranelift-pure.s"),
            "gcc":  os.path.join(OUTPUTS_DIR, f"{name}.gcc-pure.s"),
        }
        row = {"program": name, "func": func}
        for key, path in sources.items():
            row[key] = _fmt_count(*count_asm(path, func))
        rows.append(row)
    return rows


def main():
    ensure_programs()
    rows = []
    print("Benchmark de compiladores\n" + "=" * 60)
    for name in PROGRAMS:
        txt_path = os.path.join(BENCH_DIR, f"{name}.txt")
        rs_path = os.path.join(BENCH_DIR, f"{name}.rs")
        c_path = os.path.join(BENCH_DIR, f"{name}.c")

        ours = bench_compiler(txt_path)
        rustc_ms = bench_rustc(rs_path)
        clif_ms = bench_rustc_clif(rs_path)
        gcc_ms = bench_gcc(c_path)

        # Guardar el x86 generado por cada compilador (fuera del cronometrado)
        save_assembly(name, txt_path, rs_path, c_path)

        row = {
            "program": f"{name}.rs",
            "ours_ms": ours,
            "rustc_ms": rustc_ms,
            "clif_ms": clif_ms,
            "gcc_ms": gcc_ms,
            "rustc_note": RUSTC_NOTES.get(name, ""),
        }
        if ours and rustc_ms:
            row["ratio_rustc"] = round(rustc_ms / ours, 2)
        if ours and clif_ms:
            row["ratio_clif"] = round(clif_ms / ours, 2)
        if ours and gcc_ms:
            row["ratio_gcc"] = round(gcc_ms / ours, 2)
        rows.append(row)

        rustc_s = f"{rustc_ms:.2f}ms" if rustc_ms else "N/A"
        clif_s = f"{clif_ms:.2f}ms" if clif_ms else "N/A"
        gcc_s = f"{gcc_ms:.2f}ms" if gcc_ms else "N/A"
        ours_s = f"{ours:.2f}ms" if ours else "ERROR"
        print(f"{name:12} nuestro={ours_s:>10}  rustc={rustc_s:>10}  clif={clif_s:>10}  gcc={gcc_s:>10}")

    csv_path = os.path.join(OUT_DIR, "results.csv")
    fields = ["program", "ours_ms", "rustc_ms", "clif_ms", "gcc_ms",
              "ratio_rustc", "ratio_clif", "ratio_gcc", "rustc_note"]
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        w.writeheader()
        for r in rows:
            w.writerow(r)

    md_path = os.path.join(OUT_DIR, "results.md")
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("# Benchmark — Comparación Comercial\n\n")
        f.write("| Programa | Nuestro (ms) | Rustc/LLVM (ms) | Rustc/Cranelift (ms) | GCC (ms) "
                "| Ratio rustc/ours | Ratio clif/ours | Ratio gcc/ours |\n")
        f.write("|---|---:|---:|---:|---:|---:|---:|---:|\n")
        for r in rows:
            f.write(
                f"| {r['program']} | {r.get('ours_ms', 'N/A')} | {r.get('rustc_ms', 'N/A')} "
                f"| {r.get('clif_ms', 'N/A')} | {r.get('gcc_ms', 'N/A')} "
                f"| {r.get('ratio_rustc', '—')} | {r.get('ratio_clif', '—')} | {r.get('ratio_gcc', '—')} |\n"
            )
        f.write("\n*Menor tiempo = mejor. Ratio > 1 indica que nuestro compilador es más rápido.*\n\n")
        f.write(
            "**Backends de rustc:** *LLVM* es el backend por defecto (optimizador completo, "
            "compilación más lenta); *Cranelift* (cg_clif, nightly `-Zcodegen-backend=cranelift`) "
            "prioriza velocidad de compilación sobre calidad del código generado — es la "
            "comparación más justa de \"velocidad de compilación\" sobre la misma fuente `.rs`.\n\n")

        # --- Cuadro nuevo: tamaño del código x86 generado (comparación justa) ---
        asm_rows = asm_line_counts()
        f.write("## Tamaño del código x86 generado (comparación justa: solo la función, sin I/O)\n\n")
        f.write("| Programa (función) | Nuestro | Rustc/LLVM (-O2) | Rustc/Cranelift | GCC (-O2) |\n")
        f.write("|---|---:|---:|---:|---:|\n")
        for r in asm_rows:
            f.write(
                f"| {r['program']} (`{r['func']}`) | {r['ours']} | {r['llvm']} "
                f"| {r['clif']} | {r['gcc']} |\n"
            )
        f.write(
            "\n*Cada celda = **instrucciones de la función** / **líneas totales del `.s`**.* "
            "Las tres columnas comerciales usan **variantes puras** (`extern \"C\"` en Rust / "
            "función C, sin `main` ni `println!`/`printf`, `-O2`), por eso son comparables con "
            "nuestro output ya limpio. `strings` se omite por ser solo I/O.\n\n"
            "**Observaciones:** a `-O2`, tanto LLVM como GCC pliegan "
            "`matrix_kernel`/`loop_sum_kernel` a una **constante** (constant folding total del "
            "bucle: `return 2` / `return 499500`) — optimización que nuestro compilador no "
            "realiza (emite el bucle completo). Cranelift, en cambio, **no** las pliega (optimiza "
            "poco, prioriza velocidad de compilación). En `fib` (recursivo, no plegable) el "
            "contraste se invierte: GCC **desenrolla y vectoriza** la recursión convertida en "
            "bucle, disparando su conteo de instrucciones muy por encima de LLVM y del nuestro — "
            "otro ejemplo de optimización comercial agresiva.\n\n")

        f.write("## Notas sobre rustc\n\n")
        for name, note in RUSTC_NOTES.items():
            f.write(f"- **{name}.rs**: {note}\n")
        f.write(
            "\nLos benchmarks usan la **misma lógica** en los cuatro programas; "
            "para rustc/GCC se usan archivos `.rs`/`.c` con sintaxis estándar donde aplica, "
            "o se reporta N/A cuando el dialecto del proyecto difiere de Rust oficial.\n"
        )

    print(f"\nResultados: {csv_path}\n           {md_path}")
    print(f"x86 generado:  {OUTPUTS_DIR}  (<programa>.<compilador>.s)")


if __name__ == "__main__":
    main()
