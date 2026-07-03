#ifndef AST_JSON_H
#define AST_JSON_H

#include "ast.h"
#include "visitor.h"
#include <ostream>
#include <sstream>
#include <string>

class ASTJsonVisitor : public Visitor {
public:
    std::string exportProgram(Program* program);

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
    std::ostringstream json;
    int indent = 0;

    void writeIndent();
    void writeExp(Exp* exp);
    void writeStm(Stm* stm);
};

#endif
