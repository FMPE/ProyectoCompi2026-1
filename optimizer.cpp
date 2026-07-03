#include "optimizer.h"
#include <sstream>
#include <algorithm>

// ============================================================================
// PEEPHOLE OPTIMIZER
// ============================================================================

std::vector<std::string> PeepholeOptimizer::optimize(
    const std::vector<std::string>& instructions) {

    std::vector<std::string> result = instructions;
    bool changed = true;
    int passes = 0;
    const int MAX_PASSES = 5;

    while (changed && passes < MAX_PASSES) {
        changed = false;
        passes++;

        for (size_t i = 0; i < result.size(); ++i) {
            if (eliminateRedundantMoves(result, i))   { changed = true; continue; }
            if (strengthReduction(result, i))         { changed = true; continue; }
            if (eliminateDeadCode(result, i))         { changed = true; continue; }
            if (combineConstantOperations(result, i)) { changed = true; continue; }
            if (optimizeZeroComparisons(result, i))   { changed = true; continue; }
            if (constantPropagation(result, i))       { changed = true; continue; }
        }
    }

    // Eliminar líneas vacías (marcadas para eliminación)
    std::vector<std::string> cleaned;
    for (const auto& instr : result) {
        if (!instr.empty()) cleaned.push_back(instr);
    }

    return cleaned;
}

// Elimina movimientos redundantes: movq %rax, %rax
bool PeepholeOptimizer::eliminateRedundantMoves(
    std::vector<std::string>& instructions, size_t& i) {

    std::string& instr = instructions[i];
    std::istringstream iss(instr);
    std::string op, src, dst;
    iss >> op >> src >> dst;

    if (op == "movq" || op == "movl") {
        if (!src.empty() && src.back() == ',') src.pop_back();
        if (src == dst && !src.empty() && src[0] == '%') {
            instructions[i] = "";
            return true;
        }
    }

    return false;
}

// Combina operaciones con constantes consecutivas
bool PeepholeOptimizer::combineConstantOperations(
    std::vector<std::string>& instructions, size_t& i) {

    if (i + 1 >= instructions.size()) return false;

    std::istringstream iss1(instructions[i]);
    std::string op1, src1, dst1;
    iss1 >> op1 >> src1 >> dst1;

    if (op1 == "movq" || op1 == "movl") {
        if (!src1.empty() && src1.back() == ',') src1.pop_back();

        if (isImmediate(src1)) {
            std::istringstream iss2(instructions[i + 1]);
            std::string op2, src2, dst2;
            iss2 >> op2 >> src2 >> dst2;

            if (!src2.empty() && src2.back() == ',') src2.pop_back();

            if ((op2 == "addq" || op2 == "addl") && isImmediate(src2) && dst1 == dst2) {
                long long val1 = getImmediateValue(src1);
                long long val2 = getImmediateValue(src2);
                instructions[i] = " " + op1 + " $" + std::to_string(val1 + val2) + ", " + dst1;
                instructions[i + 1] = "";
                return true;
            }

            if ((op2 == "subq" || op2 == "subl") && isImmediate(src2) && dst1 == dst2) {
                long long val1 = getImmediateValue(src1);
                long long val2 = getImmediateValue(src2);
                instructions[i] = " " + op1 + " $" + std::to_string(val1 - val2) + ", " + dst1;
                instructions[i + 1] = "";
                return true;
            }
        }
    }

    return false;
}

// Elimina código muerto
bool PeepholeOptimizer::eliminateDeadCode(
    std::vector<std::string>& instructions, size_t& i) {

    if (i + 1 >= instructions.size()) return false;

    std::istringstream iss1(instructions[i]);
    std::string op1, src1, dst1;
    iss1 >> op1 >> src1 >> dst1;

    if (op1 == "movq" || op1 == "movl") {
        if (!src1.empty() && src1.back() == ',') src1.pop_back();

        if (dst1.find('(') != std::string::npos) return false;

        std::istringstream iss2(instructions[i + 1]);
        std::string op2, src2, dst2;
        iss2 >> op2 >> src2 >> dst2;

        if ((op2 == "movq" || op2 == "movl") && dst1 == dst2) {
            // No eliminar si i+1 LEE el registro antes de sobrescribirlo,
            // p. ej. 'movq -8(%rbp),%rax' seguido de 'movq (%rax),%rax':
            // el segundo usa %rax como dirección base, así que el primero
            // NO es código muerto.
            std::string reg1 = dst1;
            if (!reg1.empty() && reg1.back() == ',') reg1.pop_back();
            if (src2.find(reg1) != std::string::npos) return false;
            instructions[i] = "";
            return true;
        }
    }

    return false;
}

// STRENGTH REDUCTION - Reemplaza operaciones costosas por equivalentes rápidas
bool PeepholeOptimizer::strengthReduction(
    std::vector<std::string>& instructions, size_t& i) {

    std::istringstream iss(instructions[i]);
    std::string op, src, dst;
    iss >> op >> src >> dst;

    if (!src.empty() && src.back() == ',') src.pop_back();

    // addq $1, %rax → incq %rax
    if ((op == "addq" || op == "addl") && src == "$1") {
        std::string newOp = (op == "addq") ? "incq" : "incl";
        instructions[i] = " " + newOp + " " + dst;
        return true;
    }

    // subq $1, %rax → decq %rax
    if ((op == "subq" || op == "subl") && src == "$1") {
        std::string newOp = (op == "subq") ? "decq" : "decl";
        instructions[i] = " " + newOp + " " + dst;
        return true;
    }

    // imulq $2, %rax → shlq $1, %rax
    if ((op == "imulq" || op == "imull") && src == "$2") {
        std::string newOp = (op == "imulq") ? "shlq" : "shll";
        instructions[i] = " " + newOp + " $1, " + dst;
        return true;
    }

    // imulq $4, %rax → shlq $2, %rax
    if ((op == "imulq" || op == "imull") && src == "$4") {
        std::string newOp = (op == "imulq") ? "shlq" : "shll";
        instructions[i] = " " + newOp + " $2, " + dst;
        return true;
    }

    // imulq $8, %rax → shlq $3, %rax
    if ((op == "imulq" || op == "imull") && src == "$8") {
        std::string newOp = (op == "imulq") ? "shlq" : "shll";
        instructions[i] = " " + newOp + " $3, " + dst;
        return true;
    }

    // addq $0 / subq $0, %rax → eliminar
    if ((op == "addq" || op == "addl" || op == "subq" || op == "subl") && src == "$0") {
        instructions[i] = "";
        return true;
    }

    // imulq $1, %rax → eliminar
    if ((op == "imulq" || op == "imull") && src == "$1") {
        instructions[i] = "";
        return true;
    }

    return false;
}

// PROPAGACIÓN DE CONSTANTES
//
// Al ver 'movq $imm, %reg', busca hacia adelante usos de %reg como operando
// fuente en un 'movq/movl %reg, %dst' y los sustituye por el inmediato
// ('movq $imm, %dst'), que es semánticamente idéntico mientras %reg conserve
// el valor. El escaneo se detiene ante cualquier barrera que pueda invalidar
// el conocimiento del registro: redefinición de %reg, uso de %reg en
// direccionamiento de memoria/aritmética, etiquetas, saltos, call, ret o leave.
bool PeepholeOptimizer::constantPropagation(
    std::vector<std::string>& instructions, size_t& i) {

    std::istringstream iss(instructions[i]);
    std::string op, src, dst;
    iss >> op >> src >> dst;

    if (op != "movq" && op != "movl") return false;
    if (src.empty() || src.back() != ',') return false;  // formato 'op src, dst'
    src.pop_back();
    if (!isImmediate(src)) return false;
    if (dst.empty() || dst[0] != '%' || dst.find('(') != std::string::npos) return false;

    const std::string reg = dst;
    const std::string imm = src;

    for (size_t j = i + 1; j < instructions.size(); ++j) {
        const std::string& line = instructions[j];
        if (line.empty()) continue;

        // Barrera: etiqueta (termina en ':')
        if (!line.empty() && line.back() == ':') break;

        std::istringstream jss(line);
        std::string jop, a, b;
        jss >> jop >> a >> b;

        // Barrera de flujo/pila: saltos (j*), call, ret, leave, push/pop
        if (jop == "call" || jop == "ret" || jop == "leave" ||
            jop == "pushq" || jop == "popq" ||
            (!jop.empty() && jop[0] == 'j')) {
            break;
        }

        if (!a.empty() && a.back() == ',') a.pop_back();

        // Sustitución: movq/movl %reg, %dst  →  movq/movl $imm, %dst
        if ((jop == "movq" || jop == "movl") && a == reg &&
            !b.empty() && b[0] == '%' &&
            b.find('(') == std::string::npos) {
            instructions[j] = " " + jop + " " + imm + ", " + b;
            return true;
        }

        // %reg redefinido como destino → deja de ser conocido
        if (b == reg) break;

        // Cualquier otra aparición de %reg (memoria, aritmética, etc.):
        if (a.find(reg) != std::string::npos || b.find(reg) != std::string::npos) break;
    }

    return false;
}

// cmpq $0, %rax → testq %rax, %rax
bool PeepholeOptimizer::optimizeZeroComparisons(
    std::vector<std::string>& instructions, size_t& i) {

    std::istringstream iss1(instructions[i]);
    std::string op1, src1, dst1;
    iss1 >> op1 >> src1 >> dst1;

    if (op1 == "cmpq" || op1 == "cmpl") {
        if (!src1.empty() && src1.back() == ',') src1.pop_back();

        if (src1 == "$0" && !dst1.empty() && dst1[0] == '%') {
            std::string newOp = (op1 == "cmpq") ? "testq" : "testl";
            instructions[i] = " " + newOp + " " + dst1 + ", " + dst1;
            return true;
        }
    }

    return false;
}

bool PeepholeOptimizer::isImmediate(const std::string& operand) {
    return !operand.empty() && operand[0] == '$';
}

long long PeepholeOptimizer::getImmediateValue(const std::string& operand) {
    if (!isImmediate(operand)) return 0;
    return std::stoll(operand.substr(1));
}

// ============================================================================
// CodeOptimizer - Wrapper principal
// ============================================================================

std::vector<std::string> CodeOptimizer::optimizeCode(
    const std::vector<std::string>& code) {

    stats.originalInstructions = static_cast<int>(code.size());
    std::vector<std::string> result = code;

    if (enablePeephole) {
        size_t beforePeephole = result.size();
        result = peepholeOpt.optimize(result);
        stats.peepholeReductions = static_cast<int>(beforePeephole - result.size());
    }

    stats.optimizedInstructions = static_cast<int>(result.size());
    return result;
}
