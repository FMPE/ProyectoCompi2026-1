#!/usr/bin/env python3
"""Compila el compilador y lo copia al simulador."""
import os
import shutil
import subprocess
import platform

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCES = [
    "main.cpp", "scanner.cpp", "token.cpp", "parser.cpp", "ast.cpp",
    "visitor.cpp", "optimizer.cpp", "constfold.cpp", "json_utils.cpp",
    "ast_json.cpp", "compiler_api.cpp"
]

OUT = "compiler.exe" if platform.system() == "Windows" else "compiler"
SIM_DIR = os.path.join(ROOT, "simulador_completo", "backend")

cmd = ["g++", "-std=c++17", "-O2", "-o", OUT] + SOURCES
print("Compilando:", " ".join(cmd))
r = subprocess.run(cmd, cwd=ROOT)
if r.returncode != 0:
    raise SystemExit(1)

dest = os.path.join(SIM_DIR, OUT)
shutil.copy2(os.path.join(ROOT, OUT), dest)
print(f"OK → {dest}")

# También copiar como a.exe / a.out en raíz para tests
alt = os.path.join(ROOT, "a.exe" if platform.system() == "Windows" else "a.out")
shutil.copy2(os.path.join(ROOT, OUT), alt)
print(f"OK → {alt}")
