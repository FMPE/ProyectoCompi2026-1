#ifndef OPTIMIZER_H
#define OPTIMIZER_H

#include <string>
#include <vector>

// ============================================================================
// Optimización Peephole (mirilla): reglas locales sobre el ensamblador ya
// generado (post-procesamiento de una función a la vez).
//
// Nota: la eliminación de subexpresiones comunes (CSE) NO vive aquí; se
// realiza a nivel de AST durante la generación de código en visitor.cpp
// (dagCache / generateExprSignature / lookupDAGCache / saveToDAGCache).
// ============================================================================

class PeepholeOptimizer {
public:
    PeepholeOptimizer() = default;

    // Aplica las optimizaciones peephole a una lista de instrucciones.
    std::vector<std::string> optimize(const std::vector<std::string>& instructions);

private:
    // Reglas de optimización específicas

    // Elimina movimientos redundantes: movq %rax, %rax
    bool eliminateRedundantMoves(std::vector<std::string>& instructions, size_t& i);

    // Combina operaciones con constantes: movq $5, %rax + addq $3, %rax -> movq $8, %rax
    bool combineConstantOperations(std::vector<std::string>& instructions, size_t& i);

    // Elimina código muerto: movq seguido de otro movq al mismo registro
    bool eliminateDeadCode(std::vector<std::string>& instructions, size_t& i);

    // Fortalecimiento de operaciones: addq $1 -> incq, imulq $2 -> shlq $1, ...
    bool strengthReduction(std::vector<std::string>& instructions, size_t& i);

    // Propagación de constantes: si un registro tiene un inmediato conocido,
    // sustituirlo en usos posteriores como operando fuente.
    bool constantPropagation(std::vector<std::string>& instructions, size_t& i);

    // Optimización de comparaciones con 0: cmpq $0, %reg -> testq %reg, %reg
    bool optimizeZeroComparisons(std::vector<std::string>& instructions, size_t& i);

    // Funciones auxiliares
    bool isImmediate(const std::string& operand);
    long long getImmediateValue(const std::string& operand);
};

// ============================================================================
// Wrapper para aplicar las optimizaciones habilitadas.
// ============================================================================

class CodeOptimizer {
public:
    CodeOptimizer() : enablePeephole(true) {}

    // Aplica todas las optimizaciones habilitadas.
    std::vector<std::string> optimizeCode(const std::vector<std::string>& code);

    void setPeepholeOptimization(bool enable) { enablePeephole = enable; }

    // Estadísticas
    struct Stats {
        int originalInstructions = 0;
        int optimizedInstructions = 0;
        int peepholeReductions = 0;
    };

    const Stats& getStats() const { return stats; }
    void resetStats() { stats = Stats(); }

private:
    bool enablePeephole;
    Stats stats;

    PeepholeOptimizer peepholeOpt;
};

#endif // OPTIMIZER_H
