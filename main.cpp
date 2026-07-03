// main.cpp - Compilador Rust simplificado → x86-64
#include <iostream>
#include <fstream>
#include <string>
#include "scanner.h"
#include "parser.h"
#include "ast.h"
#include "visitor.h"
#include "compiler_api.h"

using namespace std;

int main(int argc, const char* argv[]) {
    if (argc < 2) {
        cout << "Uso: " << argv[0] << " <archivo> [--no-opt] [--stats] [--emit-json]" << endl;
        cout << "  --no-opt     Deshabilitar optimizaciones" << endl;
        cout << "  --stats      Mostrar estadísticas de optimización" << endl;
        cout << "  --emit-json  Emitir reporte JSON completo (tokens, AST, asm, stats)" << endl;
        return 1;
    }

    bool enableOptimizations = true;
    bool showStats = false;
    bool emitJson = false;

    for (int i = 2; i < argc; i++) {
        string arg = argv[i];
        if (arg == "--no-opt") enableOptimizations = false;
        else if (arg == "--stats") showStats = true;
        else if (arg == "--emit-json") emitJson = true;
    }

    ifstream infile(argv[1]);
    if (!infile.is_open()) {
        cerr << "No se pudo abrir el archivo: " << argv[1] << endl;
        return 1;
    }

    string input, line;
    while (getline(infile, line)) input += line + '\n';
    infile.close();

    if (emitJson) {
        CompileResult result = compileSource(input, enableOptimizations);
        cout << compileResultToJson(result) << endl;
        return result.success ? 0 : 1;
    }

    try {
        Scanner scanner(input.c_str());
        Parser parser(&scanner);
        Program* program = parser.parseProgram();

        string inputFile(argv[1]);
        size_t dotPos = inputFile.find_last_of('.');
        string baseName = (dotPos == string::npos) ? inputFile : inputFile.substr(0, dotPos);
        string outputFilename = baseName + ".s";
        ofstream outfile(outputFilename);
        if (!outfile.is_open()) {
            cerr << "Error al crear el archivo de salida: " << outputFilename << endl;
            return 1;
        }

        cout << "Generando codigo ensamblador en " << outputFilename << endl;
        cout << (enableOptimizations
                     ? "Optimizaciones: HABILITADAS (constant folding AST, Sethi-Ullman, "
                       "dead-function elim, CSE/DAG, peephole)\n"
                     : "Optimizaciones: DESHABILITADAS\n");

        GenCodeVisitor codigo(outfile);
        codigo.enableOptimizations(enableOptimizations);
        codigo.enableDAGOptimization(enableOptimizations);
        codigo.enablePeepholeOptimization(enableOptimizations);
        codigo.generar(program);
        outfile.close();

        if (showStats && enableOptimizations) {
            cout << "\n";
            codigo.printOptimizationStats(cout);
        }

        cout << "\nCompilación exitosa!" << endl;
        delete program;
    } catch (const exception& ex) {
        cerr << "Error de compilación: " << ex.what() << endl;
        return 1;
    }

    return 0;
}
