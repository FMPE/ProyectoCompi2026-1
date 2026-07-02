#!/usr/bin/env python3
"""
Backend Flask - Compilador Rust → x86-64
Proyecto Compiladores CS3402 - UTEC
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import subprocess
import tempfile
import os
import uuid
import shutil
import signal
import sys
import json
import platform

app = Flask(__name__, static_folder='static')
CORS(app)

PORT = 5002
BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
COMPILER_NAME = 'compiler.exe' if platform.system() == 'Windows' else 'compiler'
COMPILER_PATH = os.path.join(BACKEND_DIR, COMPILER_NAME)


def _normalize_source(source_code):
    """Acepta str o dict (p. ej. JSON de PowerShell ConvertTo-Json sobre Get-Content)."""
    if isinstance(source_code, str):
        return source_code
    if isinstance(source_code, dict):
        for key in ('value', 'Value', 'content', 'Content'):
            if key in source_code and isinstance(source_code[key], str):
                return source_code[key]
        if isinstance(source_code.get('code'), str):
            return source_code['code']
    if isinstance(source_code, list):
        return '\n'.join(str(line) for line in source_code)
    return None


def run_compiler(source_code, enable_opt=True):
    source_code = _normalize_source(source_code)
    if not source_code:
        return {'success': False, 'error': 'El código fuente debe ser texto'}

    session_id = str(uuid.uuid4())[:8]
    work_dir = os.path.join(tempfile.gettempdir(), f'rustc_{session_id}')
    os.makedirs(work_dir, exist_ok=True)

    try:
        src_file = os.path.join(work_dir, 'prog.rs')
        with open(src_file, 'w', encoding='utf-8') as f:
            f.write(source_code)

        cmd = [COMPILER_PATH, src_file, '--emit-json']
        if not enable_opt:
            cmd.append('--no-opt')

        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=15, cwd=work_dir
        )

        stdout = result.stdout.strip()
        if stdout:
            try:
                data = json.loads(stdout)
                return data
            except json.JSONDecodeError:
                pass

        stderr = result.stderr.strip()
        return {
            'success': False,
            'error': stderr or stdout or 'Error desconocido del compilador',
            'tokens': [],
            'ast': None,
            'assembly': '',
            'stats': {}
        }
    except subprocess.TimeoutExpired:
        return {'success': False, 'error': 'Timeout de compilación (>15s)'}
    except FileNotFoundError:
        return {
            'success': False,
            'error': f'Compilador no encontrado en {COMPILER_PATH}. Ejecuta: python scripts/build.py'
        }
    except Exception as e:
        return {'success': False, 'error': str(e)}
    finally:
        shutil.rmtree(work_dir, ignore_errors=True)


@app.route('/')
def index():
    resp = send_from_directory('static', 'index.html')
    resp.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    return resp


@app.route('/api/compile', methods=['POST'])
def compile_endpoint():
    data = request.get_json()
    if not data or 'code' not in data:
        return jsonify({'success': False, 'error': 'No se envió código'}), 400
    enable_opt = data.get('optimize', True)
    return jsonify(run_compiler(data['code'], enable_opt))


@app.route('/api/ast', methods=['POST'])
def ast_endpoint():
    data = request.get_json()
    if not data or 'code' not in data:
        return jsonify({'success': False, 'error': 'No se envió código'}), 400
    result = run_compiler(data['code'])
    return jsonify({
        'success': result.get('success', False),
        'ast': result.get('ast'),
        'error': result.get('error')
    })


@app.route('/api/tokens', methods=['POST'])
def tokens_endpoint():
    data = request.get_json()
    if not data or 'code' not in data:
        return jsonify({'success': False, 'error': 'No se envió código'}), 400
    result = run_compiler(data['code'])
    return jsonify({
        'success': result.get('success', False),
        'tokens': result.get('tokens', []),
        'error': result.get('error')
    })


@app.route('/api/health')
def health():
    return jsonify({
        'status': 'ok',
        'compiler_exists': os.path.exists(COMPILER_PATH),
        'compiler_path': COMPILER_PATH,
        'platform': platform.system()
    })


def signal_handler(sig, frame):
    print('\n[INFO] Cerrando servidor...')
    sys.exit(0)


if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    print('=' * 50)
    print('Compilador Rust → x86-64 | CS3402 UTEC')
    print('=' * 50)
    print(f'Compilador: {COMPILER_PATH}')
    print(f'  {"OK" if os.path.exists(COMPILER_PATH) else "NO ENCONTRADO - ejecuta python scripts/build.py"}')
    print(f'URL: http://localhost:{PORT}')
    print('=' * 50)
    app.run(host='127.0.0.1', port=PORT, debug=False, threaded=False)
