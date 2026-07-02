#include "visitor.h"

#include "ast.h"

#include <stdexcept>
#include <string>
#include <vector>
#include <cstring>
#include <cstdint>
#include <sstream>
#include <algorithm>

using std::string;
using std::vector;

namespace {
const vector<string> kArgRegisters = {"%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9"};

string resolve_alias(string name); // definido más abajo

Type::TType resolve_type(const string& name) {
    // Resolver alias de tipo primero (p. ej. "MyInt" -> "i32") para que el enum
    // se reconozca; si no, quedaría NOTYPE y el codegen usaría tamaño erróneo.
    auto tt = Type::string_to_type(resolve_alias(name));
    return tt;
}

struct StructLayout {
    int size;
    std::unordered_map<std::string, int> offsets;
    std::unordered_map<std::string, std::string> types;
};
static std::unordered_map<std::string, StructLayout> globalStructLayouts;
static std::unordered_map<std::string, std::string> globalTypeAliases;

string resolve_alias(string name) {
    while (globalTypeAliases.count(name)) {
        name = globalTypeAliases[name];
    }
    return name;
}

int arrayElementCount(const string& typeName) {
    int total = 1;
    size_t pos = 0;
    while ((pos = typeName.find('[', pos)) != string::npos) {
        size_t close = typeName.find(']', pos);
        if (close == string::npos) break;
        total *= stoi(typeName.substr(pos + 1, close - pos - 1));
        pos = close + 1;
    }
    return total;
}

// Un tipo puntero/referencia se representa con prefijo '&' o '*'
// (p. ej. "&i32", "*mut Point"); '~' marca un Box<T> (propiedad en heap).
// Todos ocupan 8 bytes en x86-64.
inline bool isPointerType(const string& t) {
    return !t.empty() && (t[0] == '&' || t[0] == '*' || t[0] == '~');
}
inline string pointeeType(const string& t) {
    return isPointerType(t) ? t.substr(1) : t;
}

int typeSizeBytes(const string& rawType) {
    string typeName = resolve_alias(rawType);
    if (isPointerType(typeName)) return 8;
    if (typeName == "String") return 8;
    if (typeName.find("[") != string::npos) {
        return arrayElementCount(typeName) * 4;
    }
    if (globalStructLayouts.count(typeName)) {
        return globalStructLayouts[typeName].size;
    }
    if (typeName == "i32" || typeName == "bool" || typeName == "u32" || typeName == "f32") {
        return 4;
    }
    return 8;
}

void collectStringLiteralsFromExp(Exp* exp, std::unordered_map<string, string>& pool, int& counter) {
    if (!exp) return;
    if (StringExp* s = dynamic_cast<StringExp*>(exp)) {
        if (!pool.count(s->value)) {
            pool[s->value] = "str_lit_" + to_string(counter++);
        }
    }
    if (BinaryExp* b = dynamic_cast<BinaryExp*>(exp)) {
        collectStringLiteralsFromExp(b->left, pool, counter);
        collectStringLiteralsFromExp(b->right, pool, counter);
    } else if (ArrayAccessExp* a = dynamic_cast<ArrayAccessExp*>(exp)) {
        collectStringLiteralsFromExp(a->array, pool, counter);
        collectStringLiteralsFromExp(a->index, pool, counter);
    } else if (FieldAccessExp* f = dynamic_cast<FieldAccessExp*>(exp)) {
        collectStringLiteralsFromExp(f->object, pool, counter);
    } else if (FcallExp* fc = dynamic_cast<FcallExp*>(exp)) {
        for (auto arg : fc->argumentos) collectStringLiteralsFromExp(arg, pool, counter);
    } else if (StructInitExp* si = dynamic_cast<StructInitExp*>(exp)) {
        for (auto& field : si->fields) collectStringLiteralsFromExp(field.second, pool, counter);
    }
}

void collectStringLiteralsFromStm(Stm* stm, std::unordered_map<string, string>& pool, int& counter) {
    if (!stm) return;
    if (LetStm* let = dynamic_cast<LetStm*>(stm)) {
        collectStringLiteralsFromExp(let->init, pool, counter);
    } else if (PrintStm* p = dynamic_cast<PrintStm*>(stm)) {
        collectStringLiteralsFromExp(p->e, pool, counter);
    } else if (AssignStm* a = dynamic_cast<AssignStm*>(stm)) {
        collectStringLiteralsFromExp(a->e, pool, counter);
    } else if (ReturnStm* r = dynamic_cast<ReturnStm*>(stm)) {
        collectStringLiteralsFromExp(r->e, pool, counter);
    } else if (IfStm* i = dynamic_cast<IfStm*>(stm)) {
        collectStringLiteralsFromExp(i->condition, pool, counter);
        if (i->thenBlock) for (auto s : i->thenBlock->statements) collectStringLiteralsFromStm(s, pool, counter);
        if (i->elseBlock) for (auto s : i->elseBlock->statements) collectStringLiteralsFromStm(s, pool, counter);
    } else if (WhileStm* w = dynamic_cast<WhileStm*>(stm)) {
        collectStringLiteralsFromExp(w->condition, pool, counter);
        if (w->body) for (auto s : w->body->statements) collectStringLiteralsFromStm(s, pool, counter);
    } else if (ForStm* f = dynamic_cast<ForStm*>(stm)) {
        collectStringLiteralsFromExp(f->start, pool, counter);
        collectStringLiteralsFromExp(f->end, pool, counter);
        if (f->body) for (auto s : f->body->statements) collectStringLiteralsFromStm(s, pool, counter);
    } else if (BlockStm* b = dynamic_cast<BlockStm*>(stm)) {
        for (auto s : b->statements) collectStringLiteralsFromStm(s, pool, counter);
    }
}

void collectStringLiterals(Program* program, std::unordered_map<string, string>& pool, int& counter) {
    for (auto fn : program->fdlist) {
        if (!fn || !fn->cuerpo) continue;
        for (auto stm : fn->cuerpo->stmlist) {
            if (BlockStm* block = dynamic_cast<BlockStm*>(stm)) {
                for (auto s : block->statements) collectStringLiteralsFromStm(s, pool, counter);
            }
        }
    }
}

string escapeAsmString(const string& s) {
    string out;
    for (char c : s) {
        if (c == '"') out += "\\\"";
        else if (c == '\\') out += "\\\\";
        else if (c == '\n') out += "\\n";
        else out += c;
    }
    return out;
}

vector<int> parseArrayDimensions(const string& typeName) {
    vector<int> dims;
    size_t pos = 0;
    while ((pos = typeName.find('[', pos)) != string::npos) {
        size_t close = typeName.find(']', pos);
        if (close == string::npos) break;
        dims.push_back(stoi(typeName.substr(pos + 1, close - pos - 1)));
        pos = close + 1;
    }
    return dims;
}

int arrayStrideAtDepth(const string& typeName, size_t depth, int elemSize = 4) {
    auto dims = parseArrayDimensions(typeName);
    int stride = elemSize;
    for (size_t i = depth + 1; i < dims.size(); ++i) {
        stride *= dims[i];
    }
    return stride;
}
}

// -----------------------------------------------------------------------------
// GenCodeVisitor helpers
// -----------------------------------------------------------------------------

GenCodeVisitor::GenCodeVisitor(std::ostream& output)
    : out(output) {}

string GenCodeVisitor::makeLabel(const string& base) {
    return ".L_" + base + "_" + std::to_string(nextLabelId++);
}

SymbolInfo GenCodeVisitor::declareLocal(const string& name, const SymbolInfo& infoTemplate) {
    SymbolInfo info = infoTemplate;
    info.offset = nextStackOffset;
    nextStackOffset -= 8;
    symbols.declare(name, info);
    return info;
}

const SymbolInfo* GenCodeVisitor::lookupSymbol(const string& name) const {
    return symbols.lookup(name);
}

SymbolInfo* GenCodeVisitor::lookupSymbol(const string& name) {
    return symbols.lookup(name);
}

// =============================================================================
// IMPLEMENTACIÓN DE OPTIMIZACIÓN DAG
// =============================================================================

// Genera una firma única para una expresión (para el cache DAG)
std::string GenCodeVisitor::generateExprSignature(Exp* exp) {
    if (!exp) return "";
    
    if (NumberExp* num = dynamic_cast<NumberExp*>(exp)) {
        return "NUM:" + std::to_string(num->value);
    }
    
    if (BoolExp* b = dynamic_cast<BoolExp*>(exp)) {
        return "BOOL:" + std::to_string(b->valor ? 1 : 0);
    }
    
    if (IdExp* id = dynamic_cast<IdExp*>(exp)) {
        return "ID:" + id->value;
    }
    
    if (BinaryExp* bin = dynamic_cast<BinaryExp*>(exp)) {
        string leftSig = generateExprSignature(bin->left);
        string rightSig = generateExprSignature(bin->right);
        string opStr;
        switch (bin->op) {
            case PLUS_OP: opStr = "+"; break;
            case MINUS_OP: opStr = "-"; break;
            case MUL_OP: opStr = "*"; break;
            case DIV_OP: opStr = "/"; break;
            default: return ""; // No cachear otras operaciones
        }
        return "BIN:(" + leftSig + ")" + opStr + "(" + rightSig + ")";
    }
    
    // No cachear otras expresiones (llamadas a funciones, arrays, etc.)
    return "";
}

// Busca una expresión en el cache DAG
DAGCacheEntry* GenCodeVisitor::lookupDAGCache(const std::string& signature) {
    if (!dagEnabled || signature.empty()) return nullptr;
    
    auto it = dagCache.find(signature);
    if (it != dagCache.end()) {
        return &(it->second);
    }
    return nullptr;
}

// Guarda una expresión en el cache DAG
void GenCodeVisitor::saveToDAGCache(const std::string& signature, int offset, Type::TType type) {
    if (!dagEnabled || signature.empty()) return;
    
    DAGCacheEntry entry;
    entry.offset = offset;
    entry.type = type;
    entry.signature = signature;
    dagCache[signature] = entry;
}

// Invalida entradas del cache que dependen de una variable
void GenCodeVisitor::invalidateDAGCache(const std::string& varName) {
    if (!dagEnabled) return;
    
    string pattern = "ID:" + varName;
    
    // Eliminar todas las entradas que contienen esta variable
    auto it = dagCache.begin();
    while (it != dagCache.end()) {
        if (it->first.find(pattern) != string::npos) {
            it = dagCache.erase(it);
        } else {
            ++it;
        }
    }
}

// Limpia todo el cache DAG
void GenCodeVisitor::clearDAGCache() {
    dagCache.clear();
    dagHits = 0;
    dagMisses = 0;
}

// =============================================================================
// BUFFERING PARA PEEPHOLE
// =============================================================================

void GenCodeVisitor::startBuffering() {
    if (optimizationsEnabled) {
        bufferingOutput = true;
        tempOutput.str("");
        tempOutput.clear();
    }
}

void GenCodeVisitor::flushOptimizedBuffer() {
    if (!bufferingOutput) return;
    
    bufferingOutput = false;
    
    string generatedCode = tempOutput.str();
    
    if (!optimizationsEnabled || generatedCode.empty()) {
        out << generatedCode;
        return;
    }
    
    std::vector<std::string> instructions;
    std::istringstream iss(generatedCode);
    std::string line;
    while (std::getline(iss, line)) {
        if (!line.empty()) {
            instructions.push_back(line);
        }
    }
    
    optimizer.resetStats();
    std::vector<std::string> optimized = optimizer.optimizeCode(instructions);
    
    for (const auto& instr : optimized) {
        out << instr << "\n";
    }
}

void GenCodeVisitor::printOptimizationStats(std::ostream& os) {
    const auto& stats = optimizer.getStats();
    os << "=== Estadísticas de Optimización ===\n";
    os << "Instrucciones originales: " << stats.originalInstructions << "\n";
    os << "Instrucciones optimizadas: " << stats.optimizedInstructions << "\n";
    os << "Subexpresiones reutilizadas (DAG): " << dagHits << "\n";
    os << "Reducciones por Peephole: " << stats.peepholeReductions << "\n";
}

CodeOptimizer::Stats GenCodeVisitor::getOptimizationStats() const {
    return optimizer.getStats();
}

void GenCodeVisitor::prepareStringLiterals(Program* program) {
    stringLiterals.clear();
    nextStringId = 0;
    collectStringLiterals(program, stringLiterals, nextStringId);
}

string GenCodeVisitor::labelForString(const string& value) const {
    auto it = stringLiterals.find(value);
    if (it != stringLiterals.end()) return it->second;
    return "str_lit_0";
}

void GenCodeVisitor::emitArrayAddress(ArrayAccessExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    vector<ArrayAccessExp*> chain;
    Exp* cur = exp;
    while (ArrayAccessExp* nested = dynamic_cast<ArrayAccessExp*>(cur)) {
        chain.push_back(nested);
        cur = nested->array;
    }
    IdExp* id = dynamic_cast<IdExp*>(cur);
    if (!id) throw std::runtime_error("Acceso a array requiere identificador base");

    const SymbolInfo* info = lookupSymbol(id->value);
    if (!info) throw std::runtime_error("Array no declarado: " + id->value);

    string typeName = resolve_alias(info->typeName);
    targetOut << " leaq " << info->offset << "(%rbp), %rax\n";

    for (size_t i = 0; i < chain.size(); ++i) {
        int stride = arrayStrideAtDepth(typeName, i);
        targetOut << " pushq %rax\n";
        chain[i]->index->accept(this);
        targetOut << " movq %rax, %rcx\n";
        targetOut << " popq %rax\n";
        if (stride == 4) {
            targetOut << " leaq (%rax, %rcx, 4), %rax\n";
        } else if (stride == 8) {
            targetOut << " leaq (%rax, %rcx, 8), %rax\n";
        } else {
            targetOut << " imulq $" << stride << ", %rcx\n";
            targetOut << " addq %rcx, %rax\n";
        }
    }
}

// -----------------------------------------------------------------------------
// Gestión de memoria dinámica (Box) con RAII
// -----------------------------------------------------------------------------

void GenCodeVisitor::pushBoxScope() {
    boxScopes.emplace_back();
}

void GenCodeVisitor::popBoxScopeAndFree(std::ostream& targetOut) {
    if (boxScopes.empty()) return;
    for (int offset : boxScopes.back()) {
        targetOut << " movq " << offset << "(%rbp), %rdi\n";
        targetOut << " call free@PLT\n";
    }
    boxScopes.pop_back();
}

void GenCodeVisitor::emitFreeAllBoxes(std::ostream& targetOut) {
    // Libera todos los Box vivos (de scope interno a externo) sin desapilar:
    // se usa antes de un 'return' que salta los free textuales de los pop.
    for (auto it = boxScopes.rbegin(); it != boxScopes.rend(); ++it) {
        for (int offset : *it) {
            targetOut << " movq " << offset << "(%rbp), %rdi\n";
            targetOut << " call free@PLT\n";
        }
    }
}

// -----------------------------------------------------------------------------
// GenCodeVisitor
// -----------------------------------------------------------------------------

int GenCodeVisitor::generar(Program* program) {
    frameReservation.clear();
    typeChecker.analyze(program);
    frameReservation = typeChecker.frameSlots;
    prepareStringLiterals(program);
    return program->accept(this);
}

int GenCodeVisitor::visit(Program* program) {
    out << ".data\n";
    for (const auto& entry : stringLiterals) {
        out << entry.second << ": .string \"" << escapeAsmString(entry.first) << "\\0\"\n";
    }
    out << "print_fmt: .string \"%ld \\n\"\n";
    out << "print_float_fmt: .string \"%f \\n\"\n";
    out << "print_str_fmt: .string \"%s\\n\"\n";

    for (auto globalDecl : program->vdlist) {
        if (globalDecl) {
            globalDecl->accept(this);
        }
    }

    for (auto it = globalSymbols.begin(); it != globalSymbols.end(); ++it) {
        out << it->second << ": .quad 0\n";
    }

    out << ".text\n";

    for (auto typeAlias : program->talist) {
        if (typeAlias) {
            typeAlias->accept(this);
        }
    }

    for (auto structDecl : program->sdlist) {
        if (structDecl) {
            structDecl->accept(this);
        }
    }

    for (auto functionDecl : program->fdlist) {
        if (functionDecl) {
            functionDecl->accept(this);
        }
    }

    out << ".section .note.GNU-stack,\"\",@progbits\n";
    return 0;
}

int GenCodeVisitor::visit(FunDec* function) {
    insideFunction = true;
    symbols.clear();
    symbols.push_scope();
    boxScopes.clear();
    pushBoxScope();
    nextStackOffset = -8;

    // Limpiar cache DAG al inicio de cada función
    clearDAGCache();

    currentFunctionName = function->nombre;
    currentReturnLabel = ".L_return_" + function->nombre;

    out << ".globl " << function->nombre << "\n";
    out << function->nombre << ":\n";
    out << " pushq %rbp\n";
    out << " movq %rsp, %rbp\n";

    int reservedSlots = 0;
    auto it = frameReservation.find(function->nombre);
    if (it != frameReservation.end()) {
        reservedSlots = it->second;
    }
    // Agregar slots extra para cache DAG de subexpresiones
    reservedSlots += 10; // Espacio extra para subexpresiones cacheadas
    
    int frameBytes = reservedSlots * 8;
    if (frameBytes > 0) {
        out << " subq $" << frameBytes << ", %rsp\n";
    }

    auto paramCount = function->Nparametros.size();
    for (std::size_t idx = 0; idx < paramCount && idx < kArgRegisters.size(); ++idx) {
        SymbolInfo tmpl;
        tmpl.isMutable = false;
        tmpl.initialized = true;
        tmpl.type = resolve_type(function->Tparametros[idx]);
        tmpl.typeName = function->Tparametros[idx];
        SymbolInfo info = declareLocal(function->Nparametros[idx], tmpl);
        out << " movq " << kArgRegisters[idx] << ", " << info.offset << "(%rbp)\n";
    }

    startBuffering();

    if (function->cuerpo) {
        function->cuerpo->accept(this);
    }

    flushOptimizedBuffer();

    out << " movq $0, %rax\n";
    out << currentReturnLabel << ":\n";
    out << " leave\n";
    out << " ret\n";

    symbols.clear();
    insideFunction = false;
    currentFunctionName.clear();
    currentReturnLabel.clear();
    return 0;
}

int GenCodeVisitor::visit(Body* body) {
    for (auto decl : body->vdlist) {
        if (decl) {
            decl->accept(this);
        }
    }
    for (auto stmt : body->stmlist) {
        if (stmt) {
            stmt->accept(this);
        }
    }
    return 0;
}

int GenCodeVisitor::visit(BlockStm* block) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    symbols.push_scope();
    pushBoxScope();
    for (auto stmt : block->statements) {
        if (stmt) {
            stmt->accept(this);
        }
    }
    popBoxScopeAndFree(targetOut); // RAII: libera los Box del scope
    symbols.pop_scope();
    return 0;
}

int GenCodeVisitor::visit(LetStm* letStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    if (!insideFunction) {
        if (globalSymbols.find(letStmt->name) == globalSymbols.end()) {
            globalSymbols.emplace(letStmt->name, letStmt->name);
        }
        return 0;
    }

    SymbolInfo tmpl;
    tmpl.isMutable = letStmt->mutable_flag;
    tmpl.initialized = letStmt->init != nullptr;
    tmpl.type = resolve_type(letStmt->type_name);
    tmpl.typeName = letStmt->type_name;

    int size = typeSizeBytes(letStmt->type_name);
    if (tmpl.type == Type::NOTYPE && letStmt->type_name == "String") {
        tmpl.type = Type::STRING;
    }

    int alignedSize = (size + 7) / 8 * 8;
    int offset = nextStackOffset - alignedSize + 8;
    nextStackOffset -= alignedSize;

    tmpl.offset = offset;
    symbols.declare(letStmt->name, tmpl);

    // Caso especial: literal de arreglo repetido [valor; N] (anidable).
    // Reserva ya hecha arriba; aquí rellenamos cada celda con el valor hoja.
    if (ArrayRepeatExp* lit = dynamic_cast<ArrayRepeatExp*>(letStmt->init)) {
        Exp* leaf = lit;
        while (ArrayRepeatExp* r = dynamic_cast<ArrayRepeatExp*>(leaf)) leaf = r->value;
        int elemSize = 4;                 // i32
        int total = (elemSize > 0) ? size / elemSize : 0;
        leaf->accept(this);               // valor hoja (p. ej. 0) -> %eax
        for (int k = 0; k < total; ++k)
            targetOut << " movl %eax, " << (tmpl.offset + k * elemSize) << "(%rbp)\n";
        return 0;
    }

    if (letStmt->init) {
        // Verificar si la expresión de inicialización está en cache DAG
        string signature = generateExprSignature(letStmt->init);
        DAGCacheEntry* cached = lookupDAGCache(signature);
        
        if (cached) {
            dagHits++;
            targetOut << " # DAG: reutilizando subexpresion\n";
            if (cached->type == Type::I32 || cached->type == Type::U32 || cached->type == Type::F32) {
                targetOut << " movl " << cached->offset << "(%rbp), %eax\n";
            } else {
                targetOut << " movq " << cached->offset << "(%rbp), %rax\n";
            }
        } else {
            dagMisses++;
            letStmt->init->accept(this);
            
            // Guardar en cache DAG si es una expresión binaria
            if (!signature.empty() && dynamic_cast<BinaryExp*>(letStmt->init)) {
                saveToDAGCache(signature, tmpl.offset, tmpl.type);
            }
        }
        
        Type::TType rhsType = lastType;

        // Para inicializaciones con puntero/deref/Box, el tipo real sólo se
        // conoce tras generar el código (lastTypeName). Corregimos el símbolo
        // aquí para que las desreferencias posteriores usen el tipo correcto.
        if (dynamic_cast<AddressOfExp*>(letStmt->init) ||
            dynamic_cast<DerefExp*>(letStmt->init) ||
            dynamic_cast<BoxNewExp*>(letStmt->init)) {
            if (SymbolInfo* sym = lookupSymbol(letStmt->name)) {
                sym->typeName = lastTypeName;
                sym->type = isPointerType(lastTypeName) ? Type::I64 : resolve_type(lastTypeName);
            }
        }

        // RAII: sólo un 'let x = Box::new(..)' directo posee la memoria y se
        // libera al cerrar el scope. 'let c = b;' (copia) no se registra para
        // evitar doble free.
        if (dynamic_cast<BoxNewExp*>(letStmt->init) && !boxScopes.empty()) {
            boxScopes.back().push_back(tmpl.offset);
        }

        if (tmpl.type == Type::F32 && (rhsType == Type::F64 || rhsType == Type::NOTYPE)) {
            targetOut << " movq %rax, %xmm0\n";
            targetOut << " cvtsd2ss %xmm0, %xmm0\n";
            targetOut << " movd %xmm0, %eax\n";
            targetOut << " movl %eax, " << tmpl.offset << "(%rbp)\n";
        } else if (size <= 8) {
            if (size == 4) {
                targetOut << " movl %eax, " << tmpl.offset << "(%rbp)\n";
            } else {
                targetOut << " movq %rax, " << tmpl.offset << "(%rbp)\n";
            }
        } else {
            targetOut << " movq %rax, %rsi\n";
            targetOut << " leaq " << tmpl.offset << "(%rbp), %rdi\n";
            targetOut << " movq $" << size << ", %rcx\n";
            targetOut << " rep movsb\n";
        }
    } else {
        if (size <= 8) {
            targetOut << " movq $0, " << tmpl.offset << "(%rbp)\n";
        }
    }

    return 0;
}

int GenCodeVisitor::visit(IfStm* ifStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    string elseLabel = makeLabel("else");
    string endLabel = makeLabel("endif");
    
    // Limpiar cache DAG en control de flujo
    clearDAGCache();

    ifStmt->condition->accept(this);
    targetOut << " cmpq $0, %rax\n";
    targetOut << " je " << elseLabel << "\n";

    if (ifStmt->thenBlock) {
        ifStmt->thenBlock->accept(this);
    }
    targetOut << " jmp " << endLabel << "\n";

    targetOut << elseLabel << ":\n";
    clearDAGCache(); // Limpiar al entrar en else
    if (ifStmt->elseBlock) {
        ifStmt->elseBlock->accept(this);
    }
    targetOut << endLabel << ":\n";
    clearDAGCache(); // Limpiar al salir
    return 0;
}

int GenCodeVisitor::visit(WhileStm* whileStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    string startLabel = makeLabel("while_begin");
    string endLabel = makeLabel("while_end");
    
    // Limpiar cache DAG en loops
    clearDAGCache();

    targetOut << startLabel << ":\n";
    whileStmt->condition->accept(this);
    targetOut << " cmpq $0, %rax\n";
    targetOut << " je " << endLabel << "\n";

    if (whileStmt->body) {
        whileStmt->body->accept(this);
    }

    targetOut << " jmp " << startLabel << "\n";
    targetOut << endLabel << ":\n";
    clearDAGCache();
    return 0;
}

int GenCodeVisitor::visit(ForStm* forStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    symbols.push_scope();
    pushBoxScope();
    clearDAGCache();

    SymbolInfo tmpl;
    tmpl.isMutable = true;
    tmpl.initialized = true;
    tmpl.type = Type::I64;
    SymbolInfo iterInfo = declareLocal(forStmt->iteratorName, tmpl);

    if (forStmt->start) {
        forStmt->start->accept(this);
    } else {
        targetOut << " movq $0, %rax\n";
    }
    targetOut << " movq %rax, " << iterInfo.offset << "(%rbp)\n";

    string loopLabel = makeLabel("for_begin");
    string endLabel = makeLabel("for_end");

    targetOut << loopLabel << ":\n";
    if (forStmt->end) {
        forStmt->end->accept(this);
    } else {
        targetOut << " movq $0, %rax\n";
    }
    targetOut << " movq %rax, %rcx\n";
    targetOut << " movq " << iterInfo.offset << "(%rbp), %rax\n";
    targetOut << " cmpq %rcx, %rax\n";
    targetOut << " jge " << endLabel << "\n";

    if (forStmt->body) {
        forStmt->body->accept(this);
    }

    targetOut << " movq " << iterInfo.offset << "(%rbp), %rax\n";
    targetOut << " addq $1, %rax\n";
    targetOut << " movq %rax, " << iterInfo.offset << "(%rbp)\n";
    targetOut << " jmp " << loopLabel << "\n";
    targetOut << endLabel << ":\n";

    popBoxScopeAndFree(targetOut);
    symbols.pop_scope();
    clearDAGCache();
    return 0;
}

int GenCodeVisitor::visit(PrintStm* printStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    if (!printStmt->e) {
        targetOut << " movq $0, %rax\n";
    } else {
        printStmt->e->accept(this);
    }

    if (lastType == Type::STRING) {
        targetOut << " movq %rax, %rsi\n";
        targetOut << " leaq print_str_fmt(%rip), %rdi\n";
        targetOut << " movl $0, %eax\n";
        targetOut << " call printf@PLT\n";
    } else if (lastType == Type::F32 || lastType == Type::F64) {
        targetOut << " movq %rax, %xmm0\n";
        if (lastType == Type::F32) {
            targetOut << " cvtss2sd %xmm0, %xmm0\n";
        }
        targetOut << " leaq print_float_fmt(%rip), %rdi\n";
        targetOut << " movl $1, %eax\n";
        targetOut << " call printf@PLT\n";
    } else {
        targetOut << " movq %rax, %rsi\n";
        targetOut << " leaq print_fmt(%rip), %rdi\n";
        targetOut << " movl $0, %eax\n";
        targetOut << " call printf@PLT\n";
    }
    return 0;
}

int GenCodeVisitor::visit(AssignStm* assignStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    if (assignStmt->id == "_") {
        if (assignStmt->e) {
            assignStmt->e->accept(this);
        }
        return 0;
    }

    if (!assignStmt->e) {
        throw std::runtime_error("Asignación sin expresión para " + assignStmt->id);
    }

    assignStmt->e->accept(this);
    
    // Invalidar cache DAG cuando se modifica una variable
    invalidateDAGCache(assignStmt->id);

    if (auto* info = lookupSymbol(assignStmt->id)) {
        info->initialized = true;
        targetOut << " movq %rax, " << info->offset << "(%rbp)\n";
        return 0;
    }

    auto globalIt = globalSymbols.find(assignStmt->id);
    if (globalIt != globalSymbols.end()) {
        targetOut << " movq %rax, " << globalIt->second << "(%rip)\n";
        return 0;
    }

    throw std::runtime_error("Identificador no declarado: " + assignStmt->id);
}

int GenCodeVisitor::visit(ReturnStm* returnStmt) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    if (returnStmt->e) {
        returnStmt->e->accept(this);
    } else {
        targetOut << " movq $0, %rax\n";
    }
    // RAII: liberar los Box vivos antes de saltar (el jmp evita los free de los
    // pop de scope). Se preserva %rax (valor de retorno) porque free() lo altera.
    bool hasBoxes = false;
    for (const auto& s : boxScopes) if (!s.empty()) { hasBoxes = true; break; }
    if (hasBoxes) {
        targetOut << " pushq %rax\n";
        emitFreeAllBoxes(targetOut);
        targetOut << " popq %rax\n";
    }
    targetOut << " jmp " << currentReturnLabel << "\n";
    return 0;
}

int GenCodeVisitor::visit(VarDec* varDec) {
    if (!insideFunction) {
        for (const auto& name : varDec->variables) {
            if (globalSymbols.find(name) == globalSymbols.end()) {
                globalSymbols.emplace(name, name);
            }
        }
        return 0;
    }

    for (const auto& name : varDec->variables) {
        SymbolInfo tmpl;
        tmpl.isMutable = true;
        tmpl.initialized = false;
        tmpl.type = resolve_type(varDec->tipo);
        declareLocal(name, tmpl);
    }
    return 0;
}

int GenCodeVisitor::visit(BinaryExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    if (exp->op == ASSIGN_OP) {
        if (IdExp* idExp = dynamic_cast<IdExp*>(exp->left)) {
            string name = idExp->value;

            exp->right->accept(this);
            Type::TType rhsType = lastType;
            
            // Invalidar cache DAG para esta variable
            invalidateDAGCache(name);

            if (auto* info = lookupSymbol(name)) {
                info->initialized = true;

                string typeName = resolve_alias(info->typeName);
                int size = 8;
                if (typeName.find("[") != string::npos) {
                    size_t open = typeName.find("[");
                    size_t close = typeName.find("]");
                    int count = stoi(typeName.substr(open + 1, close - open - 1));
                    size = count * 4;
                } else if (globalStructLayouts.count(typeName)) {
                    size = globalStructLayouts[typeName].size;
                } else if (info->type == Type::F32) {
                    size = 4;
                } else if (info->type == Type::I32 || info->type == Type::U32) {
                    size = 4;
                }

                if (info->type == Type::F32 && (rhsType == Type::F64 || rhsType == Type::NOTYPE)) {
                    targetOut << " movq %rax, %xmm0\n";
                    targetOut << " cvtsd2ss %xmm0, %xmm0\n";
                    targetOut << " movd %xmm0, %eax\n";
                    targetOut << " movl %eax, " << info->offset << "(%rbp)\n";
                    return 0;
                }

                if (size > 8) {
                    targetOut << " movq %rax, %rsi\n";
                    targetOut << " leaq " << info->offset << "(%rbp), %rdi\n";
                    targetOut << " movq $" << size << ", %rcx\n";
                    targetOut << " rep movsb\n";
                } else {
                    if (size == 4) {
                        targetOut << " movl %eax, " << info->offset << "(%rbp)\n";
                    } else {
                        targetOut << " movq %rax, " << info->offset << "(%rbp)\n";
                    }
                }
                return 0;
            }

            auto globalIt = globalSymbols.find(name);
            if (globalIt != globalSymbols.end()) {
                targetOut << " movq %rax, " << globalIt->second << "(%rip)\n";
                return 0;
            }
            throw std::runtime_error("Identificador no declarado: " + name);

        } else if (ArrayAccessExp* arrExp = dynamic_cast<ArrayAccessExp*>(exp->left)) {
            emitArrayAddress(arrExp);
            targetOut << " pushq %rax\n";
            exp->right->accept(this);
            targetOut << " popq %rdi\n";
            targetOut << " movl %eax, (%rdi)\n";
            return 0;
        } else if (DerefExp* deref = dynamic_cast<DerefExp*>(exp->left)) {
            // *p = valor  ->  escribe a través del puntero
            deref->ptr->accept(this);              // dirección destino en %rax
            string pt = resolve_alias(pointeeType(lastTypeName));
            int size = typeSizeBytes(pt);
            targetOut << " pushq %rax\n";
            exp->right->accept(this);              // valor en %rax
            targetOut << " popq %rdi\n";
            if (size <= 4) {
                targetOut << " movl %eax, (%rdi)\n";
            } else {
                targetOut << " movq %rax, (%rdi)\n";
            }
            return 0;
        } else {
            throw std::runtime_error("Lado izquierdo de asignación no es un identificador o acceso a array");
        }
    }

    if (exp->op == AND_OP) {
        string falseLabel = makeLabel("and_false");
        string endLabel = makeLabel("and_end");

        exp->left->accept(this);
        targetOut << " cmpq $0, %rax\n";
        targetOut << " je " << falseLabel << "\n";
        exp->right->accept(this);
        targetOut << " cmpq $0, %rax\n";
        targetOut << " je " << falseLabel << "\n";
        targetOut << " movq $1, %rax\n";
        targetOut << " jmp " << endLabel << "\n";
        targetOut << falseLabel << ":\n";
        targetOut << " movq $0, %rax\n";
        targetOut << endLabel << ":\n";
        return 0;
    }

    // OPTIMIZACIÓN PEEPHOLE: Si el operando derecho es una constante, generar código directo
    NumberExp* rightNum = dynamic_cast<NumberExp*>(exp->right);
    if (rightNum && (exp->op == PLUS_OP || exp->op == MINUS_OP || exp->op == MUL_OP)) {
        exp->left->accept(this);
        Type::TType leftType = lastType;
        
        if (leftType != Type::F32 && leftType != Type::F64) {
            switch (exp->op) {
                case PLUS_OP:
                    targetOut << " addq $" << rightNum->value << ", %rax\n";
                    lastType = Type::I64;
                    return 0;
                case MINUS_OP:
                    targetOut << " subq $" << rightNum->value << ", %rax\n";
                    lastType = Type::I64;
                    return 0;
                case MUL_OP:
                    targetOut << " imulq $" << rightNum->value << ", %rax\n";
                    lastType = Type::I64;
                    return 0;
                default:
                    break;
            }
        }
    }

    // Código general para otras expresiones
    exp->left->accept(this);
    Type::TType leftType = lastType;
    targetOut << " pushq %rax\n";
    exp->right->accept(this);
    Type::TType rightType = lastType;
    targetOut << " movq %rax, %rcx\n";
    targetOut << " popq %rax\n";

    bool isFloat = (leftType == Type::F32 || leftType == Type::F64 || rightType == Type::F32 || rightType == Type::F64);

    if (isFloat) {
        targetOut << " movq %rax, %xmm0\n";
        targetOut << " movq %rcx, %xmm1\n";

        if (leftType == Type::F32 && rightType == Type::F32) {
            switch (exp->op) {
                case PLUS_OP: targetOut << " addss %xmm1, %xmm0\n"; break;
                case MINUS_OP: targetOut << " subss %xmm1, %xmm0\n"; break;
                case MUL_OP: targetOut << " mulss %xmm1, %xmm0\n"; break;
                case DIV_OP: targetOut << " divss %xmm1, %xmm0\n"; break;
                default: throw std::runtime_error("Float op not supported");
            }
            lastType = Type::F32;
        } else {
            if (leftType == Type::F32) targetOut << " cvtss2sd %xmm0, %xmm0\n";
            if (rightType == Type::F32) targetOut << " cvtss2sd %xmm1, %xmm1\n";

            switch (exp->op) {
                case PLUS_OP: targetOut << " addsd %xmm1, %xmm0\n"; break;
                case MINUS_OP: targetOut << " subsd %xmm1, %xmm0\n"; break;
                case MUL_OP: targetOut << " mulsd %xmm1, %xmm0\n"; break;
                case DIV_OP: targetOut << " divsd %xmm1, %xmm0\n"; break;
                default: throw std::runtime_error("Float op not supported");
            }
            lastType = Type::F64;
        }
        targetOut << " movq %xmm0, %rax\n";
        return 0;
    }

    switch (exp->op) {
        case PLUS_OP:
            targetOut << " addq %rcx, %rax\n";
            break;
        case MINUS_OP:
            targetOut << " subq %rcx, %rax\n";
            break;
        case MUL_OP:
            targetOut << " imulq %rcx, %rax\n";
            break;
        case DIV_OP:
            targetOut << " cqto\n";
            targetOut << " idivq %rcx\n";
            break;
        case LT_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " setl %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case GT_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " setg %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case LE_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " setle %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case GE_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " setge %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case EQ_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " sete %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case NEQ_OP:
            targetOut << " cmpq %rcx, %rax\n";
            targetOut << " movq $0, %rax\n";
            targetOut << " setne %al\n";
            targetOut << " movzbq %al, %rax\n";
            break;
        case POW_OP:
            throw std::runtime_error("Operador potencia no soportado en generador");
        default:
            throw std::runtime_error("Operador binario no soportado");
    }
    lastType = Type::I64;
    return 0;
}

int GenCodeVisitor::visit(NumberExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    targetOut << " movq $" << exp->value << ", %rax\n";
    lastType = Type::I64;
    return 0;
}

int GenCodeVisitor::visit(BoolExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    targetOut << " movq $" << (exp->valor ? 1 : 0) << ", %rax\n";
    return 0;
}

int GenCodeVisitor::visit(IdExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    if (const auto* info = lookupSymbol(exp->value)) {
        string typeName = resolve_alias(info->typeName);
        int size = 8;
        if (typeName.find("[") != string::npos) {
            size_t open = typeName.find("[");
            size_t close = typeName.find("]");
            int count = stoi(typeName.substr(open + 1, close - open - 1));
            size = count * 4;
        } else if (globalStructLayouts.count(typeName)) {
            size = globalStructLayouts[typeName].size;
        }

        if (size > 8) {
            targetOut << " leaq " << info->offset << "(%rbp), %rax\n";
        } else {
            if (info->type == Type::F32 || info->type == Type::I32 || info->type == Type::U32) {
                targetOut << " movl " << info->offset << "(%rbp), %eax\n";
            } else {
                targetOut << " movq " << info->offset << "(%rbp), %rax\n";
            }
        }
        lastType = info->type;
        lastTypeName = info->typeName;
        return 0;
    }

    auto it = globalSymbols.find(exp->value);
    if (it != globalSymbols.end()) {
        targetOut << " movq " << it->second << "(%rip), %rax\n";
        lastType = Type::I64;
        return 0;
    }

    throw std::runtime_error("Identificador no declarado: " + exp->value);
}

int GenCodeVisitor::visit(FcallExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    vector<Exp*> args(exp->argumentos.begin(), exp->argumentos.end());
    std::size_t totalArgs = args.size();
    std::size_t stackArgs = totalArgs > kArgRegisters.size() ? totalArgs - kArgRegisters.size() : 0;

    std::size_t stackAdjust = stackArgs * 8;
    if (stackAdjust % 16 != 0) {
        targetOut << " subq $8, %rsp\n";
        stackAdjust += 8;
    }

    for (std::size_t idx = totalArgs; idx > 0; --idx) {
        auto* arg = args[idx - 1];
        if (arg) {
            arg->accept(this);
        } else {
            targetOut << " movq $0, %rax\n";
        }

        if (idx - 1 >= kArgRegisters.size()) {
            targetOut << " pushq %rax\n";
        } else {
            targetOut << " movq %rax, " << kArgRegisters[idx - 1] << "\n";
        }
    }

    targetOut << " call " << exp->nombre << "\n";

    if (stackAdjust > 0) {
        targetOut << " addq $" << stackAdjust << ", %rsp\n";
    }
    return 0;
}

int GenCodeVisitor::visit(StructDec* sd) {
    StructLayout layout;
    int currentOffset = 0;
    for (auto& field : sd->fields) {
        layout.offsets[field.first] = currentOffset;
        layout.types[field.first] = field.second;
        string type = field.second;
        int size = 8;
        if (type.find("[") != string::npos) {
            size_t open = type.find("[");
            size_t close = type.find("]");
            int count = stoi(type.substr(open + 1, close - open - 1));
            size = count * 4;
        } else if (type == "i32" || type == "bool" || type == "u32" || type == "f32") {
            size = 4;
        }
        layout.offsets[field.first] = currentOffset;
        currentOffset += size;
    }
    layout.size = currentOffset;
    globalStructLayouts[sd->name] = layout;
    return 0;
}

int GenCodeVisitor::visit(ArrayAccessExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    emitArrayAddress(exp);
    targetOut << " movl (%rax), %eax\n";
    targetOut << " cltq\n";
    lastType = Type::I32;
    return 0;
}

int GenCodeVisitor::visit(ArrayRepeatExp* exp) {
    // El relleno de un literal de arreglo se maneja en visit(LetStm).
    // Fuera de una inicialización no está soportado; no-op seguro.
    (void)exp;
    return 0;
}

int GenCodeVisitor::visit(CastExp* exp) {
    // Solo se soporta i32 -> usize, que a nivel de máquina es un no-op:
    // el valor ya queda en %rax/%eax y el cálculo de direcciones de arreglo
    // (emitArrayAddress) lo usa como índice de 64 bits.
    if (exp->value) exp->value->accept(this);
    if (exp->targetType == "usize") { lastType = Type::USIZE; return 0; }
    throw std::runtime_error("cast 'as " + exp->targetType + "' no soportado (solo i32 -> usize)");
}

int GenCodeVisitor::visit(AddressOfExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    Exp* t = exp->target;

    // &variable  ->  dirección del slot en la pila
    if (IdExp* id = dynamic_cast<IdExp*>(t)) {
        const SymbolInfo* info = lookupSymbol(id->value);
        if (!info) throw std::runtime_error("Variable no declarada en '&': " + id->value);
        targetOut << " leaq " << info->offset << "(%rbp), %rax\n";
        lastType = Type::I64;
        lastTypeName = "&" + info->typeName;
        return 0;
    }

    // &arr[i]  ->  reutiliza el cálculo de dirección de arreglo
    if (ArrayAccessExp* arr = dynamic_cast<ArrayAccessExp*>(t)) {
        emitArrayAddress(arr);
        lastType = Type::I64;
        lastTypeName = "&i32"; // los elementos de arreglo son i32
        return 0;
    }

    // &obj.campo  ->  dirección base + offset del campo
    if (FieldAccessExp* fa = dynamic_cast<FieldAccessExp*>(t)) {
        if (IdExp* obj = dynamic_cast<IdExp*>(fa->object)) {
            if (const auto* info = lookupSymbol(obj->value)) {
                string typeName = resolve_alias(info->typeName);
                if (globalStructLayouts.count(typeName)) {
                    int off = globalStructLayouts[typeName].offsets[fa->field];
                    string ft = globalStructLayouts[typeName].types[fa->field];
                    targetOut << " leaq " << info->offset << "(%rbp), %rax\n";
                    targetOut << " addq $" << off << ", %rax\n";
                    lastType = Type::I64;
                    lastTypeName = "&" + ft;
                    return 0;
                }
            }
        }
    }

    throw std::runtime_error("Operando de '&' no es un lvalue soportado");
}

int GenCodeVisitor::visit(DerefExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    exp->ptr->accept(this); // el puntero queda en %rax

    string pt = resolve_alias(pointeeType(lastTypeName));
    int size = typeSizeBytes(pt);
    bool isFloat = (pt == "f32" || pt == "f64");

    if (size <= 4) {
        targetOut << " movl (%rax), %eax\n";
        if (!isFloat) targetOut << " cltq\n";
    } else {
        targetOut << " movq (%rax), %rax\n";
    }

    lastType = resolve_type(pt);
    if (lastType == Type::NOTYPE) lastType = (size <= 4) ? Type::I32 : Type::I64;
    lastTypeName = pt;
    return 0;
}

int GenCodeVisitor::visit(BoxNewExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;

    exp->value->accept(this);                    // valor -> %rax; fija lastType

    // El tamaño y el tipo apuntado se derivan del tipo del valor evaluado
    // (el placeholder del parser no es fiable para variables).
    int size; string ptName;
    switch (lastType) {
        case Type::I32:   size = 4; ptName = "i32";   break;
        case Type::U32:   size = 4; ptName = "u32";   break;
        case Type::F32:   size = 4; ptName = "f32";   break;
        case Type::BOOL:  size = 4; ptName = "bool";  break;
        case Type::I64:   size = 8; ptName = "i64";   break;
        case Type::U64:   size = 8; ptName = "u64";   break;
        case Type::USIZE: size = 8; ptName = "usize"; break;
        case Type::F64:   size = 8; ptName = "f64";   break;
        default:          size = 8; ptName = "i64";   break;
    }

    // Guarda el valor con ajuste múltiplo de 16 (neutral a la alineación) para
    // que la llamada a malloc quede correctamente alineada.
    targetOut << " subq $16, %rsp\n";
    targetOut << " movq %rax, (%rsp)\n";
    targetOut << " movq $" << size << ", %rdi\n";
    targetOut << " call malloc@PLT\n";           // puntero heap -> %rax
    targetOut << " movq (%rsp), %rdx\n";         // recupera el valor
    targetOut << " addq $16, %rsp\n";
    if (size <= 4) {
        targetOut << " movl %edx, (%rax)\n";     // celda = valor
    } else {
        targetOut << " movq %rdx, (%rax)\n";
    }
    lastType = Type::I64;
    lastTypeName = "~" + ptName;
    return 0;
}

int GenCodeVisitor::visit(FieldAccessExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    if (IdExp* id = dynamic_cast<IdExp*>(exp->object)) {
        if (const auto* info = lookupSymbol(id->value)) {
            targetOut << " leaq " << info->offset << "(%rbp), %rax\n";
            string typeName = resolve_alias(info->typeName);
            if (globalStructLayouts.count(typeName)) {
                int offset = globalStructLayouts[typeName].offsets[exp->field];
                string fieldType = globalStructLayouts[typeName].types[exp->field];
                targetOut << " addq $" << offset << ", %rax\n";

                if (fieldType == "i64" || fieldType == "u64" || fieldType == "f64") {
                    targetOut << " movq (%rax), %rax\n";
                } else {
                    targetOut << " movl (%rax), %eax\n";
                    targetOut << " cltq\n";
                }
                return 0;
            }
        }
    }
    throw std::runtime_error("Field access error");
}

int GenCodeVisitor::visit(StructInitExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    string resolvedName = resolve_alias(exp->name);
    if (globalStructLayouts.count(resolvedName)) {
        auto& layout = globalStructLayouts[resolvedName];
        int size = layout.size;

        int alignedSize = (size + 7) / 8 * 8;

        int structBaseOffset = nextStackOffset - alignedSize + 8;
        nextStackOffset -= alignedSize;

        for (auto& field : exp->fields) {
            string fname = field.first;
            Exp* expr = field.second;
            int fieldOffset = layout.offsets[fname];
            string ftype = layout.types[fname];

            expr->accept(this);

            if (ftype == "i32" || ftype == "bool") {
                targetOut << " movl %eax, " << (structBaseOffset + fieldOffset) << "(%rbp)\n";
            } else {
                targetOut << " movq %rax, " << (structBaseOffset + fieldOffset) << "(%rbp)\n";
            }
        }

        if (size <= 8) {
            targetOut << " movq " << structBaseOffset << "(%rbp), %rax\n";
        } else {
            targetOut << " leaq " << structBaseOffset << "(%rbp), %rax\n";
        }
    }
    return 0;
}

int GenCodeVisitor::visit(TypeAlias* ta) {
    globalTypeAliases[ta->alias] = ta->type;
    return 0;
}

int GenCodeVisitor::visit(FloatExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    double v = exp->value;
    uint64_t bits;
    std::memcpy(&bits, &v, sizeof(bits));
    targetOut << " movabsq $" << bits << ", %rax\n";
    targetOut << " movq %rax, %xmm0\n";
    lastType = exp->isDouble ? Type::F64 : Type::F32;
    return 0;
}

int GenCodeVisitor::visit(StringExp* exp) {
    std::ostream& targetOut = bufferingOutput ? tempOutput : out;
    targetOut << " leaq " << labelForString(exp->value) << "(%rip), %rax\n";
    lastType = Type::STRING;
    return 0;
}

// =============================================================================
// TypeCheckerVisitor 
// =============================================================================

int TypeCheckerVisitor::analyze(Program* program) {
    frameSlots.clear();
    currentSlotCount = 0;
    program->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(Program* program) {
    for (auto typeAlias : program->talist) {
        if (typeAlias) typeAlias->accept(this);
    }
    for (auto structDecl : program->sdlist) {
        if (structDecl) structDecl->accept(this);
    }
    for (auto globalDecl : program->vdlist) {
        if (globalDecl) globalDecl->accept(this);
    }
    for (auto functionDecl : program->fdlist) {
        if (functionDecl) functionDecl->accept(this);
    }
    return 0;
}

int TypeCheckerVisitor::visit(FunDec* function) {
    currentSlotCount = static_cast<int>(function->Nparametros.size());
    if (function->cuerpo) function->cuerpo->accept(this);
    frameSlots[function->nombre] = currentSlotCount;
    currentSlotCount = 0;
    return 0;
}

int TypeCheckerVisitor::visit(Body* body) {
    for (auto decl : body->vdlist) {
        if (decl) decl->accept(this);
    }
    for (auto stmt : body->stmlist) {
        if (stmt) stmt->accept(this);
    }
    return 0;
}

int TypeCheckerVisitor::visit(BlockStm* block) {
    for (auto stmt : block->statements) {
        if (stmt) stmt->accept(this);
    }
    return 0;
}

int TypeCheckerVisitor::visit(LetStm* letStmt) {
    int sizeBytes = typeSizeBytes(letStmt->type_name);
    int slots = (sizeBytes + 7) / 8;
    currentSlotCount += slots;
    if (letStmt->init) letStmt->init->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(IfStm* ifStmt) {
    if (ifStmt->condition) ifStmt->condition->accept(this);
    if (ifStmt->thenBlock) ifStmt->thenBlock->accept(this);
    if (ifStmt->elseBlock) ifStmt->elseBlock->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(WhileStm* whileStmt) {
    if (whileStmt->condition) whileStmt->condition->accept(this);
    if (whileStmt->body) whileStmt->body->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(ForStm* forStmt) {
    ++currentSlotCount;
    if (forStmt->start) forStmt->start->accept(this);
    if (forStmt->end) forStmt->end->accept(this);
    if (forStmt->body) forStmt->body->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(PrintStm* printStmt) {
    if (printStmt->e) printStmt->e->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(AssignStm* assignStmt) {
    if (assignStmt->e) assignStmt->e->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(ReturnStm* returnStmt) {
    if (returnStmt->e) returnStmt->e->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(VarDec* varDec) {
    currentSlotCount += static_cast<int>(varDec->variables.size());
    return 0;
}

int TypeCheckerVisitor::visit(BinaryExp* exp) {
    if (exp->left) exp->left->accept(this);
    if (exp->right) exp->right->accept(this);
    return 0;
}

int TypeCheckerVisitor::visit(NumberExp*) { return 0; }
int TypeCheckerVisitor::visit(BoolExp*) { return 0; }
int TypeCheckerVisitor::visit(IdExp*) { return 0; }
int TypeCheckerVisitor::visit(FloatExp*) { return 0; }
int TypeCheckerVisitor::visit(StringExp*) { return 0; }

int TypeCheckerVisitor::visit(FcallExp* exp) {
    for (auto arg : exp->argumentos) {
        if (arg) arg->accept(this);
    }
    return 0;
}

int TypeCheckerVisitor::visit(StructDec* sd) {
    StructLayout layout;
    int currentOffset = 0;
    for (auto& field : sd->fields) {
        layout.offsets[field.first] = currentOffset;
        layout.types[field.first] = field.second;
        string type = resolve_alias(field.second);
        int size = 8;
        if (type.find("[") != string::npos) {
            size_t open = type.find("[");
            size_t close = type.find("]");
            int count = stoi(type.substr(open + 1, close - open - 1));
            size = count * 4;
        } else if (type == "i32" || type == "bool" || type == "u32" || type == "f32") {
            size = 4;
        }
        layout.offsets[field.first] = currentOffset;
        currentOffset += size;
    }
    layout.size = currentOffset;
    globalStructLayouts[sd->name] = layout;
    return 0;
}

int TypeCheckerVisitor::visit(TypeAlias* ta) {
    globalTypeAliases[ta->alias] = ta->type;
    return 0;
}

int TypeCheckerVisitor::visit(ArrayAccessExp*) { return 0; }
int TypeCheckerVisitor::visit(ArrayRepeatExp* exp) {
    if (exp->value) exp->value->accept(this);
    return 0;
}
int TypeCheckerVisitor::visit(CastExp* exp) {
    if (exp->value) exp->value->accept(this);
    return 0;
}
int TypeCheckerVisitor::visit(AddressOfExp* exp) {
    if (exp->target) exp->target->accept(this);
    return 0;
}
int TypeCheckerVisitor::visit(DerefExp* exp) {
    if (exp->ptr) exp->ptr->accept(this);
    return 0;
}
int TypeCheckerVisitor::visit(BoxNewExp* exp) {
    if (exp->value) exp->value->accept(this);
    return 0;
}
int TypeCheckerVisitor::visit(FieldAccessExp*) { return 0; }
int TypeCheckerVisitor::visit(StructInitExp* exp) {
    string resolvedName = resolve_alias(exp->name);
    if (globalStructLayouts.count(resolvedName)) {
        int size = globalStructLayouts[resolvedName].size;
        int slots = (size + 7) / 8;
        currentSlotCount += slots;
    }
    for (auto& field : exp->fields) {
        field.second->accept(this);
    }
    return 0;
}