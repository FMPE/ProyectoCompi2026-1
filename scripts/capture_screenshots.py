#!/usr/bin/env python3
"""Captura screenshots de las 6 pestañas de la app web (requiere playwright)."""
import os
import sys
import time
import subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASSETS = os.path.join(ROOT, "docs", "assets")
BACKEND = os.path.join(ROOT, "simulador_completo", "backend")
URL = "http://127.0.0.1:5002"
DEMO_CODE = """fn main() {
    let x = 5;
    let s: String = "Hola compilador";
    let mut m: i32[2][3];
    m[0][0] = x + 10;
    println("{}", m[0][0]);
    println("{}", s);
}"""

SHOTS = [
    ("screenshot_01_codigo.png", None),
    ("screenshot_02_tokens.png", "#panel-tokens"),
    ("screenshot_03_ast.png", "#panel-ast"),
    ("screenshot_04_assembly.png", "#panel-asm"),
    ("screenshot_05_simulacion.png", "#panel-sim"),
    ("screenshot_06_stats.png", "#panel-output"),
]

TAB_CLICK = {
    "#panel-tokens": "tokens",
    "#panel-ast": "ast",
    "#panel-asm": "asm",
    "#panel-sim": "sim",
    "#panel-output": "output",
}


def ensure_playwright():
    try:
        from playwright.sync_api import sync_playwright  # noqa: F401
        return True
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "playwright", "-q"])
        subprocess.check_call([sys.executable, "-m", "playwright", "install", "chromium"])
        return True


def health_ok():
    try:
        import urllib.request
        with urllib.request.urlopen(f"{URL}/api/health", timeout=3) as r:
            return r.status == 200
    except Exception:
        return False


def click_tab(page, tab_id):
    page.click(f'button.tab[data-tab="{tab_id}"]')
    time.sleep(0.4)


def main():
    os.makedirs(ASSETS, exist_ok=True)
    if not health_ok():
        print("ERROR: El servidor no responde en", URL)
        print("Ejecuta en otra terminal: cd simulador_completo/backend && python server.py")
        sys.exit(1)

    ensure_playwright()
    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page(viewport={"width": 1280, "height": 900})
        page.goto(URL, wait_until="networkidle")
        page.fill("#codeEditor", DEMO_CODE)
        page.click("#btnCompile")
        page.wait_for_timeout(2500)

        for filename, panel in SHOTS:
            if panel and panel in TAB_CLICK:
                click_tab(page, TAB_CLICK[panel])
            if panel == "#panel-sim":
                page.click("#btnRun")
                page.wait_for_timeout(1500)
            path = os.path.join(ASSETS, filename)
            page.screenshot(path=path, full_page=True)
            print("OK", path)

        browser.close()

    print(f"\nScreenshots guardados en {ASSETS}")


if __name__ == "__main__":
    main()
