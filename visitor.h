#ifndef VISITOR_H
#define VISITOR_H
#include "ast.h"
#include "environment.h"
#include "optimizer.h"
#include <list>
#include <ostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <sstream>
#include <set>

struct SymbolInfo {
    int offset = 0;
    Type::TType type = Type::NOTYPE;
    std::string typeName;
    bool isMutable = false;
    bool initialized = false;
};

// Estructura para el cache DAG de subexpresiones comunes
struct DAGCacheEntry {
    int offset;           // Offset en stack donde está guardado el resultado
    Type::TType type;     // Tipo del resultado
    std::string signature; // Firma de la expresión
};

class Visitor {
public:
    virtual ~Visitor() = default;

    virtual int visit(Program* program) = 0;
    virtual int visit(FunDec* function) = 0;
    virtual int visit(Body* body) = 0;
    virtual int visit(BlockStm* block) = 0;
    virtual int visit(LetStm* letStmt) = 0;
    virtual int visit(IfStm* ifStmt) = 0;
    virtual int visit(WhileStm* whileStmt) = 0;
    virtual int visit(ForStm* forStmt) = 0;
    virtual int visit(PrintStm* printStmt) = 0;
    virtual int visit(AssignStm* assignStmt) = 0;
    virtual int visit(ReturnStm* returnStmt) = 0;
    virtual int visit(VarDec* varDec) = 0;
    virtual int visit(StructDec* structDec) = 0;
    virtual int visit(TypeAlias* typeAlias) = 0;
    virtual int visit(StructInitExp* structInitExp) = 0;

    virtual int visit(BinaryExp* exp) = 0;
    virtual int visit(NumberExp* exp) = 0;
    virtual int visit(FloatExp* exp) = 0;
    virtual int visit(BoolExp* exp) = 0;
    virtual int visit(IdExp* exp) = 0;
    virtual int visit(FcallExp* exp) = 0;
    virtual int visit(ArrayAccessExp* exp) = 0;
    virtual int visit(ArrayRepeatExp* exp) = 0;
    virtual int visit(CastExp* exp) = 0;
    virtual int visit(FieldAccessExp* exp) = 0;
    virtual int visit(StringExp* exp) = 0;
    virtual int visit(AddressOfExp* exp) = 0;
    virtual int visit(DerefExp* exp) = 0;
    virtual int visit(BoxNewExp* exp) = 0;
    virtual int visit(LambdaExp* exp) = 0;
};

class TypeCheckerVisitor : public Visitor {
public:
    std::unordered_map<std::string, int> frameSlots;

    int analyze(Program* program);

    int visit(Program* program) override;
    int visit(FunDec* function) override;
    int visit(Body* body) override;
    int visit(BlockStm* block) override;
    int visit(LetStm* letStmt) override;
    int visit(IfStm* ifStmt) override;
    int visit(WhileStm* whileStmt) override;
    int visit(ForStm* forStmt) override;
    int visit(PrintStm* printStmt) override;
    int visit(AssignStm* assignStmt) override;
    int visit(ReturnStm* returnStmt) override;
    int visit(VarDec* varDec) override;
    int visit(StructDec* structDec) override;
    int visit(TypeAlias* typeAlias) override;
    int visit(StructInitExp* structInitExp) override;

    int visit(BinaryExp* exp) override;
    int visit(NumberExp* exp) override;
    int visit(FloatExp* exp) override;
    int visit(BoolExp* exp) override;
    int visit(IdExp* exp) override;
    int visit(FcallExp* exp) override;
    int visit(ArrayAccessExp* exp) override;
    int visit(ArrayRepeatExp* exp) override;
    int visit(CastExp* exp) override;
    int visit(FieldAccessExp* exp) override;
    int visit(StringExp* exp) override;
    int visit(AddressOfExp* exp) override;
    int visit(DerefExp* exp) override;
    int visit(BoxNewExp* exp) override;
    int visit(LambdaExp* exp) override;

private:
    int currentSlotCount = 0;
};

class GenCodeVisitor : public Visitor {
public:
    explicit GenCodeVisitor(std::ostream& output);

    int generar(Program* program);

    int visit(Program* program) override;
    int visit(FunDec* function) override;
    int visit(Body* body) override;
    int visit(BlockStm* block) override;
    int visit(LetStm* letStmt) override;
    int visit(IfStm* ifStmt) override;
    int visit(WhileStm* whileStmt) override;
    int visit(ForStm* forStmt) override;
    int visit(PrintStm* printStmt) override;
    int visit(AssignStm* assignStmt) override;
    int visit(ReturnStm* returnStmt) override;
    int visit(VarDec* varDec) override;
    int visit(StructDec* structDec) override;
    int visit(TypeAlias* typeAlias) override;
    int visit(StructInitExp* structInitExp) override;

    int visit(BinaryExp* exp) override;
    int visit(NumberExp* exp) override;
    int visit(FloatExp* exp) override;
    int visit(BoolExp* exp) override;
    int visit(IdExp* exp) override;
    int visit(FcallExp* exp) override;
    int visit(ArrayAccessExp* exp) override;
    int visit(ArrayRepeatExp* exp) override;
    int visit(CastExp* exp) override;
    int visit(FieldAccessExp* exp) override;
    int visit(StringExp* exp) override;
    int visit(AddressOfExp* exp) override;
    int visit(DerefExp* exp) override;
    int visit(BoxNewExp* exp) override;
    int visit(LambdaExp* exp) override;

    Type::TType lastType = Type::NOTYPE;
    // Tipo (como string) del último rvalue generado; transporta el tipo
    // apuntado para punteros (p. ej. "&i32") y lo usa la desreferencia.
    std::string lastTypeName;
    
    // Métodos para optimización
    void enableOptimizations(bool enable) { optimizationsEnabled = enable; }
    void enableDAGOptimization(bool enable) { dagEnabled = enable; }
    void enablePeepholeOptimization(bool enable) { optimizer.setPeepholeOptimization(enable); }
    void printOptimizationStats(std::ostream& os);
    CodeOptimizer::Stats getOptimizationStats() const;
    int getDAGHits() const { return dagHits; }

private:
    std::ostream& out;
    TypeCheckerVisitor typeChecker;
    std::unordered_map<std::string, int> frameReservation;
    Environment<SymbolInfo> symbols;
    std::unordered_map<std::string, std::string> globalSymbols;

    int nextStackOffset = -8;
    int nextLabelId = 0;
    bool insideFunction = false;
    std::string currentFunctionName;
    std::string currentReturnLabel;

    std::string makeLabel(const std::string& base);
    SymbolInfo declareLocal(const std::string& name, const SymbolInfo& infoTemplate);
    const SymbolInfo* lookupSymbol(const std::string& name) const;
    SymbolInfo* lookupSymbol(const std::string& name);
    
    // Sistema de optimización Peephole
    bool optimizationsEnabled = true;
    CodeOptimizer optimizer;
    std::ostringstream tempOutput;
    bool bufferingOutput = false;
    
    void startBuffering();
    void flushOptimizedBuffer();
    
    // ============================================
    // optimización DAG
    // ============================================
    bool dagEnabled = true;
    
    // Cache de subexpresiones comunes: signature -> offset en stack
    std::unordered_map<std::string, DAGCacheEntry> dagCache;
    
    // Contador de subexpresiones reutilizadas (para estadísticas)
    int dagHits = 0;
    int dagMisses = 0;
    
    // Genera una firma única para una expresión
    std::string generateExprSignature(Exp* exp);
    
    // Busca una expresión en el cache DAG
    DAGCacheEntry* lookupDAGCache(const std::string& signature);
    
    // Guarda una expresión en el cache DAG
    void saveToDAGCache(const std::string& signature, int offset, Type::TType type);
    
    // Invalida entradas del cache que dependen de una variable
    void invalidateDAGCache(const std::string& varName);
    
    // Limpia todo el cache DAG
    void clearDAGCache();
    
    std::unordered_map<std::string, std::string> stringLiterals;
    int nextStringId = 0;
    void prepareStringLiterals(Program* program);
    std::string labelForString(const std::string& value) const;
    void emitArrayAddress(ArrayAccessExp* exp);

    // ============================================
    // Gestión de memoria dinámica (Box) con RAII
    // ============================================
    // Offsets (en %rbp) de las variables Box gestionadas, agrupadas por scope
    // en paralelo a 'symbols'. Al cerrar un scope se emite free() para cada una.
    std::vector<std::vector<int>> boxScopes;
    void pushBoxScope();
    void popBoxScopeAndFree(std::ostream& targetOut);
    void emitFreeAllBoxes(std::ostream& targetOut);

    // ============================================
    // Genéricos: monomorfización
    // ============================================
    std::unordered_map<std::string, FunDec*> genericTemplates; // nombre -> plantilla
    // Instancias a emitir: (nombreBase, typeArgs concretos)
    std::vector<std::pair<std::string, std::vector<std::string>>> instantiations;
    std::string currentMonoLabel; // etiqueta a emitir para la instancia en curso
    void collectInstantiations(Program* program);
    std::string mangleGeneric(const std::string& base, const std::vector<std::string>& typeArgs) const;

    // ============================================================
    // Eliminación de funciones muertas (dead-function elimination)
    // ============================================================
    // Conjunto de funciones alcanzables desde 'main' (y desde las instancias
    // genéricas). Se calcula en generar() cuando las optimizaciones están
    // activas; visit(Program) sólo emite las funciones no-genéricas presentes.
    std::set<std::string> liveFunctions;
    void computeLiveFunctions(Program* program);

    // ============================================
    // Lambdas (expansión en línea, alcance acotado)
    // ============================================
    struct LambdaInfo {
        std::vector<std::string> paramNames;
        std::vector<std::string> paramTypes;
        std::vector<int> paramOffsets; // slots fijos reservados en la pila
        Exp* body = nullptr;
    };
    std::unordered_map<std::string, LambdaInfo> lambdas;
    std::set<std::string> expandingLambdas; // guardia anti-recursión
};

#endif // VISITOR_H