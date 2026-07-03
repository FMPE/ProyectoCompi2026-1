from fastapi import FastAPI, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pygdbmi.gdbcontroller import GdbController
import subprocess
import os
import shutil
from typing import Optional, Dict, Any

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global GDB controller instance
gdb_mi: Optional[GdbController] = None

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(BASE_DIR, "../../Proyecto_Compiladores"))
COMPILER_PATH = os.path.join(PROJECT_ROOT, "a.out")
TEMP_DIR = os.path.join(BASE_DIR, "temp")

os.makedirs(TEMP_DIR, exist_ok=True)

@app.post("/compile")
async def compile_code(file: UploadFile):
    try:
        # Save uploaded file
        input_path = os.path.join(TEMP_DIR, "input.txt")
        with open(input_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # 1. Run Compiler (C++)
        # Output will be input.s in the same directory
        cmd_compile = [COMPILER_PATH, input_path]
        result = subprocess.run(cmd_compile, capture_output=True, text=True, cwd=TEMP_DIR)
        
        if result.returncode != 0:
            return JSONResponse(status_code=400, content={"error": "Compilation failed", "details": result.stderr + result.stdout})

        asm_path = os.path.join(TEMP_DIR, "input.s")
        if not os.path.exists(asm_path):
             return JSONResponse(status_code=400, content={"error": "Assembly file not generated"})

        # Read assembly content
        with open(asm_path, "r") as f:
            asm_content = f.read()

        # 2. Assemble with GCC (with debug symbols)
        exe_path = os.path.join(TEMP_DIR, "program.exe")
        cmd_assemble = ["gcc", "-g", "input.s", "-o", "program.exe"]
        result_asm = subprocess.run(cmd_assemble, capture_output=True, text=True, cwd=TEMP_DIR)

        if result_asm.returncode != 0:
            return JSONResponse(status_code=400, content={"error": "Assembly failed", "details": result_asm.stderr})

        return {"message": "Compilation successful", "assembly": asm_content}

    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.post("/debug/start")
def start_debug():
    global gdb_mi
    try:
        if gdb_mi:
            gdb_mi.exit()
        
        exe_path = os.path.join(TEMP_DIR, "program.exe")
        if not os.path.exists(exe_path):
            raise HTTPException(status_code=400, detail="Executable not found. Compile first.")

        # Initialize GDB
        gdb_mi = GdbController()
        
        # Load executable
        response = gdb_mi.write(f'-file-exec-and-symbols "{exe_path}"')
        
        # Set breakpoint at main
        gdb_mi.write("-break-insert main")
        
        # Run
        gdb_mi.write("-exec-run")
        
        return get_debug_state()
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.post("/debug/step")
def step_debug():
    global gdb_mi
    if not gdb_mi:
        raise HTTPException(status_code=400, detail="Debugger not started")
    
    try:
        # Step instruction
        gdb_mi.write("-exec-step-instruction")
        return get_debug_state()
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

@app.post("/debug/stop")
def stop_debug():
    global gdb_mi
    if gdb_mi:
        gdb_mi.exit()
        gdb_mi = None
    return {"message": "Debugger stopped"}

def get_debug_state() -> Dict[str, Any]:
    global gdb_mi
    if not gdb_mi:
        return {}

    state = {
        "registers": {},
        "stack": [],
        "current_line": -1
    }

    # Get Registers
    # 1. Get register names
    resp_names = gdb_mi.write("-data-list-register-names")
    reg_names = []
    for record in resp_names:
        if record['type'] == 'done' and 'register-names' in record['payload']:
            reg_names = record['payload']['register-names']
            break
    
    # 2. Get register values
    resp_values = gdb_mi.write("-data-list-register-values x") # x for hex
    for record in resp_values:
        if record['type'] == 'done' and 'register-values' in record['payload']:
            for val in record['payload']['register-values']:
                idx = int(val['number'])
                if idx < len(reg_names):
                    name = reg_names[idx]
                    if name in ['rax', 'rbx', 'rcx', 'rdx', 'rsi', 'rdi', 'rbp', 'rsp', 'rip', 'r8', 'r9', 'r10', 'r11', 'r12', 'r13', 'r14', 'r15']:
                        state["registers"][name] = val['value']

    # Get Stack
    # We need RSP and RBP to determine stack range
    rsp_str = state["registers"].get("rsp")
    rbp_str = state["registers"].get("rbp")
    
    if rsp_str and rbp_str:
        try:
            rsp = int(rsp_str, 16)
            rbp = int(rbp_str, 16)
            
            # Read memory from RSP to RBP (or a fixed window if RBP is far)
            # Let's read 10 words from RSP
            resp_mem = gdb_mi.write(f"-data-read-memory {rsp_str} x 8 1 10")
            # Format: addr, data
            
            stack_data = []
            for record in resp_mem:
                if record['type'] == 'done' and 'memory' in record['payload']:
                    for chunk in record['payload']['memory']:
                        addr = chunk['addr']
                        data = chunk['data']
                        stack_data.append({"address": addr, "value": data[0]})
            state["stack"] = stack_data

        except ValueError:
            pass

    return state

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
