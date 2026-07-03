#include "ast_json.h"
#include "json_utils.h"
#include <sstream>

using namespace std;

void ASTJsonVisitor::writeIndent() {
    for (int i = 0; i < indent; ++i) json << "  ";
}

string ASTJsonVisitor::exportProgram(Program* program) {
    json.str("");
    json.clear();
    indent = 0;
    if (program) program->accept(this);
    return json.str();
}

int ASTJsonVisitor::visit(Program* program) {
    json << "{\n";
    indent++;
    writeIndent(); json << "\"type\": \"Program\",\n";

    writeIndent(); json << "\"functions\": [\n";
    indent++;
    bool first = true;
    for (auto fn : program->fdlist) {
        if (!first) json << ",\n";
        first = false;
        writeIndent();
        if (fn) fn->accept(this); else json << "null";
    }
    indent--;
    json << "\n"; writeIndent(); json << "],\n";

    writeIndent(); json << "\"structs\": [\n";
    indent++;
    first = true;
    for (auto sd : program->sdlist) {
        if (!first) json << ",\n";
        first = false;
        writeIndent();
        if (sd) sd->accept(this); else json << "null";
    }
    indent--;
    json << "\n"; writeIndent(); json << "],\n";

    writeIndent(); json << "\"typeAliases\": [\n";
    indent++;
    first = true;
    for (auto ta : program->talist) {
        if (!first) json << ",\n";
        first = false;
        writeIndent();
        if (ta) ta->accept(this); else json << "null";
    }
    indent--;
    json << "\n"; writeIndent(); json << "]\n";
    indent--;
    json << "}";
    return 0;
}

int ASTJsonVisitor::visit(FunDec* function) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Function\",\n";
    writeIndent(); json << "\"name\": " << jsonString(function->nombre) << ",\n";
    writeIndent(); json << "\"typeParams\": [";
    for (size_t i = 0; i < function->typeParams.size(); ++i) {
        if (i) json << ", ";
        json << jsonString(function->typeParams[i]);
    }
    json << "],\n";
    writeIndent(); json << "\"returnType\": " << jsonString(function->tipo) << ",\n";
    writeIndent(); json << "\"params\": [";
    for (size_t i = 0; i < function->Nparametros.size(); ++i) {
        if (i) json << ", ";
        json << "{" << jsonString(function->Nparametros[i]) << ": " << jsonString(function->Tparametros[i]) << "}";
    }
    json << "],\n";
    writeIndent(); json << "\"body\": ";
    if (function->cuerpo && !function->cuerpo->stmlist.empty()) {
        function->cuerpo->stmlist.front()->accept(this);
    } else json << "null";
    json << "\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(Body* body) {
    json << "[]";
    (void)body;
    return 0;
}

int ASTJsonVisitor::visit(BlockStm* block) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Block\",\n";
    writeIndent(); json << "\"statements\": [\n"; indent++;
    bool first = true;
    for (auto stm : block->statements) {
        if (!first) json << ",\n";
        first = false;
        writeIndent();
        if (stm) stm->accept(this); else json << "null";
    }
    indent--; json << "\n"; writeIndent(); json << "]\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(LetStm* letStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Let\",\n";
    writeIndent(); json << "\"mutable\": " << (letStmt->mutable_flag ? "true" : "false") << ",\n";
    writeIndent(); json << "\"name\": " << jsonString(letStmt->name) << ",\n";
    writeIndent(); json << "\"typeName\": " << jsonString(letStmt->type_name) << ",\n";
    writeIndent(); json << "\"init\": ";
    if (letStmt->init) letStmt->init->accept(this); else json << "null";
    json << "\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(IfStm* ifStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"If\",\n";
    writeIndent(); json << "\"condition\": "; ifStmt->condition->accept(this); json << ",\n";
    writeIndent(); json << "\"then\": "; ifStmt->thenBlock->accept(this); json << ",\n";
    writeIndent(); json << "\"else\": ";
    if (ifStmt->elseBlock) ifStmt->elseBlock->accept(this); else json << "null";
    json << "\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(WhileStm* whileStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"While\",\n";
    writeIndent(); json << "\"condition\": "; whileStmt->condition->accept(this); json << ",\n";
    writeIndent(); json << "\"body\": "; whileStmt->body->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(ForStm* forStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"For\",\n";
    writeIndent(); json << "\"iterator\": " << jsonString(forStmt->iteratorName) << ",\n";
    writeIndent(); json << "\"start\": "; forStmt->start->accept(this); json << ",\n";
    writeIndent(); json << "\"end\": "; forStmt->end->accept(this); json << ",\n";
    writeIndent(); json << "\"body\": "; forStmt->body->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(PrintStm* printStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Println\",\n";
    writeIndent(); json << "\"expr\": ";
    if (printStmt->e) printStmt->e->accept(this); else json << "null";
    json << "\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(AssignStm* assignStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Assign\",\n";
    writeIndent(); json << "\"name\": " << jsonString(assignStmt->id) << ",\n";
    writeIndent(); json << "\"expr\": "; assignStmt->e->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(ReturnStm* returnStmt) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Return\",\n";
    writeIndent(); json << "\"expr\": ";
    if (returnStmt->e) returnStmt->e->accept(this); else json << "null";
    json << "\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(VarDec* varDec) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"VarDec\",\n";
    writeIndent(); json << "\"varType\": " << jsonString(varDec->tipo) << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(StructDec* structDec) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Struct\",\n";
    writeIndent(); json << "\"name\": " << jsonString(structDec->name) << ",\n";
    writeIndent(); json << "\"fields\": [";
    for (size_t i = 0; i < structDec->fields.size(); ++i) {
        if (i) json << ", ";
        json << "{" << jsonString(structDec->fields[i].first) << ": " << jsonString(structDec->fields[i].second) << "}";
    }
    json << "]\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(TypeAlias* typeAlias) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"TypeAlias\",\n";
    writeIndent(); json << "\"alias\": " << jsonString(typeAlias->alias) << ",\n";
    writeIndent(); json << "\"target\": " << jsonString(typeAlias->type) << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(StructInitExp* structInitExp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"StructInit\",\n";
    writeIndent(); json << "\"name\": " << jsonString(structInitExp->name) << ",\n";
    writeIndent(); json << "\"fields\": [";
    for (size_t i = 0; i < structInitExp->fields.size(); ++i) {
        if (i) json << ", ";
        json << "{" << jsonString(structInitExp->fields[i].first) << ": ";
        structInitExp->fields[i].second->accept(this);
        json << "}";
    }
    json << "]\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(BinaryExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"BinaryOp\",\n";
    writeIndent(); json << "\"op\": " << jsonString(Exp::binopToChar(exp->op)) << ",\n";
    writeIndent(); json << "\"left\": "; exp->left->accept(this); json << ",\n";
    writeIndent(); json << "\"right\": "; exp->right->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(NumberExp* exp) {
    json << "{\"type\": \"Number\", \"value\": " << exp->value << "}";
    return 0;
}

int ASTJsonVisitor::visit(FloatExp* exp) {
    json << "{\"type\": \"Float\", \"value\": " << exp->value << ", \"isDouble\": "
         << (exp->isDouble ? "true" : "false") << "}";
    return 0;
}

int ASTJsonVisitor::visit(BoolExp* exp) {
    json << "{\"type\": \"Bool\", \"value\": " << (exp->valor ? "true" : "false") << "}";
    return 0;
}

int ASTJsonVisitor::visit(IdExp* exp) {
    json << "{\"type\": \"Identifier\", \"name\": " << jsonString(exp->value) << "}";
    return 0;
}

int ASTJsonVisitor::visit(FcallExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Call\",\n";
    writeIndent(); json << "\"name\": " << jsonString(exp->nombre) << ",\n";
    writeIndent(); json << "\"typeArgs\": [";
    for (size_t i = 0; i < exp->typeArgs.size(); ++i) {
        if (i) json << ", ";
        json << jsonString(exp->typeArgs[i]);
    }
    json << "],\n";
    writeIndent(); json << "\"args\": [";
    bool first = true;
    for (auto arg : exp->argumentos) {
        if (!first) json << ", ";
        first = false;
        if (arg) arg->accept(this); else json << "null";
    }
    json << "]\n"; indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(ArrayAccessExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"ArrayAccess\",\n";
    writeIndent(); json << "\"array\": "; exp->array->accept(this); json << ",\n";
    writeIndent(); json << "\"index\": "; exp->index->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(ArrayRepeatExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"ArrayRepeat\",\n";
    writeIndent(); json << "\"count\": " << exp->count << ",\n";
    writeIndent(); json << "\"value\": "; exp->value->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(CastExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Cast\",\n";
    writeIndent(); json << "\"target\": \"" << exp->targetType << "\",\n";
    writeIndent(); json << "\"value\": "; exp->value->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(FieldAccessExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"FieldAccess\",\n";
    writeIndent(); json << "\"object\": "; exp->object->accept(this); json << ",\n";
    writeIndent(); json << "\"field\": " << jsonString(exp->field) << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(StringExp* exp) {
    json << "{\"type\": \"String\", \"value\": " << jsonString(exp->value) << "}";
    return 0;
}

int ASTJsonVisitor::visit(AddressOfExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"AddressOf\",\n";
    writeIndent(); json << "\"mutable\": " << (exp->isMut ? "true" : "false") << ",\n";
    writeIndent(); json << "\"target\": "; exp->target->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(DerefExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Deref\",\n";
    writeIndent(); json << "\"ptr\": "; exp->ptr->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(BoxNewExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"BoxNew\",\n";
    writeIndent(); json << "\"valueType\": " << jsonString(exp->valueType) << ",\n";
    writeIndent(); json << "\"value\": "; exp->value->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}

int ASTJsonVisitor::visit(LambdaExp* exp) {
    json << "{\n"; indent++;
    writeIndent(); json << "\"type\": \"Lambda\",\n";
    writeIndent(); json << "\"params\": [";
    for (size_t i = 0; i < exp->params.size(); ++i) {
        if (i) json << ", ";
        json << "{" << jsonString(exp->params[i].first) << ": " << jsonString(exp->params[i].second) << "}";
    }
    json << "],\n";
    writeIndent(); json << "\"body\": "; exp->body->accept(this); json << "\n";
    indent--; writeIndent(); json << "}";
    return 0;
}
