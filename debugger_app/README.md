# Compiler Debugger App

This is a web-based debugger for the custom compiler.

## Prerequisites

- Python 3.8+
- GCC
- GDB
- The compiler executable `a.out` must exist in `../Proyecto_Compiladores/`.

## Setup

1.  **Install Python dependencies:**
    ```bash
    pip install -r backend/requirements.txt
    ```

2.  **Ensure GDB is installed:**
    ```bash
    sudo apt-get install gdb  # On Ubuntu/WSL
    ```

## Running the App

1.  **Start the Backend:**
    Navigate to the `backend` directory and run:
    ```bash
    cd backend
    uvicorn main:app --reload
    ```
    The API will run at `http://localhost:8000`.

2.  **Open the Frontend:**
    Open `frontend/index.html` in your web browser.

## Usage

1.  Click "Choose File" to select a source file (e.g., from `../Proyecto_Compiladores/inputs/`).
2.  Click "Compile". This will:
    - Run the C++ compiler to generate assembly.
    - Run GCC to create a debuggable executable.
    - Show the generated assembly code.
3.  Click "Start Debug" to launch GDB.
4.  Use "Step Into" to execute instruction by instruction.
5.  Observe the Registers and Stack updating in real-time.
