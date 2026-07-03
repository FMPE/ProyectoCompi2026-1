#ifndef PARSER_H       
#define PARSER_H

#include "scanner.h"
#include "ast.h"

class Parser {
private:
    Scanner* scanner;
    Token* current;
    Token* previous;
    bool silentMode = false;
    bool noStructLit = false; // prohíbe literales de struct en posición de condición

    // utilidades
    bool match(Token::Type t);
    bool check(Token::Type t);
    void advance();
    bool isAtEnd();
    void consume(Token::Type t, const string& msg);
    bool matchTypeToken();
    string parseTypeName();
    static string inferTypeFromExp(Exp* e);

    // producciones principales
    void parseItems(Program* p);
    void parseItem(Program* p);
    FunDec* parseFunction();
    StructDec* parseStruct(); 
    TypeAlias* parseTypeAlias();

    // statements / bloques
    BlockStm* parseBlock();
    Stm* parseStatement();
    LetStm* parseVarDecl();
    IfStm* parseIf();
    WhileStm* parseWhile();
    ForStm* parseFor();
    ReturnStm* parseReturn();
    PrintStm* parsePrint();

    // expresiones
    Exp* parseExpression();
    Exp* parseAssignment();
    Exp* parseOr();
    Exp* parseAnd();
    Exp* parseRel();
    Exp* parseAdd();
    Exp* parseMul();
    Exp* parseCast();
    Exp* parseUnary();
    Exp* parsePostfix();
    Exp* parsePrimary();

public:
    Parser(Scanner* sc);
    Program* parseProgram(bool silent = false);
};

#endif // PARSER_H      