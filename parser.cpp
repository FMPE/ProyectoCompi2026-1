#include <iostream>
#include <stdexcept>
#include "token.h"
#include "scanner.h"
#include "ast.h"
#include "parser.h"

using namespace std;

Parser::Parser(Scanner* sc): scanner(sc), current(nullptr), previous(nullptr) {
    advance();
}

bool Parser::check(Token::Type t){
    if (isAtEnd()) return false;
    return current->type == t;
}

void Parser::advance(){
    if (previous) delete previous;
    previous = current;
    current = scanner->nextToken();
    if (current->type == Token::ERR){
        throw runtime_error("Error léxico: token inválido '" + current->text + "'");
    }
}

bool Parser::match(Token::Type t){
    if (check(t)){ advance(); return true; }
    return false;
}

bool Parser::isAtEnd(){ return current && current->type == Token::END; }

void Parser::consume(Token::Type t, const string& msg){
    if (!match(t)) throw runtime_error("Error sintáctico: se esperaba " + msg);
}

bool Parser::matchTypeToken() {
    return match(Token::IDENTIFIER) || match(Token::STRING) ||
           match(Token::I32) || match(Token::I64) || match(Token::U32) ||
           match(Token::U64) || match(Token::USIZE) || match(Token::F32) ||
           match(Token::F64) || match(Token::BOOL);
}

string Parser::parseTypeName() {
    // Tipos referencia/puntero:  &T, &mut T, *const T, *mut T
    if (match(Token::AMP)) {
        match(Token::MUT);
        return "&" + parseTypeName();
    }
    if (match(Token::MUL)) {
        if (!match(Token::MUT)) {
            if (check(Token::IDENTIFIER) && current->text == "const") advance();
        }
        return "*" + parseTypeName();
    }
    // Box<T>  ->  se representa como puntero heap "~T"
    if (check(Token::IDENTIFIER) && current->text == "Box") {
        advance(); // Box
        consume(Token::LT, "'<' en Box<T>");
        string inner = parseTypeName();
        consume(Token::GT, "'>' en Box<T>");
        return "~" + inner;
    }
    if (!matchTypeToken()) throw runtime_error("Tipo esperado");
    string typeName = previous->text;
    while (match(Token::LBRACKET)) {
        consume(Token::NUMBER, "tamaño array");
        typeName += "[" + previous->text + "]";
        consume(Token::RBRACKET, "]");
    }
    return typeName;
}

string Parser::inferTypeFromExp(Exp* e) {
    if (dynamic_cast<NumberExp*>(e)) return "i32";
    if (FloatExp* f = dynamic_cast<FloatExp*>(e)) return f->isDouble ? "f64" : "f32";
    if (dynamic_cast<BoolExp*>(e)) return "bool";
    if (dynamic_cast<StringExp*>(e)) return "String";
    if (StructInitExp* s = dynamic_cast<StructInitExp*>(e)) return s->name;
    if (CastExp* c = dynamic_cast<CastExp*>(e)) return c->targetType;
    if (AddressOfExp* a = dynamic_cast<AddressOfExp*>(e)) {
        try { return "&" + inferTypeFromExp(a->target); }
        catch (...) { return "&i64"; }
    }
    if (dynamic_cast<DerefExp*>(e)) {
        return "i64";
    }
    if (BoxNewExp* b = dynamic_cast<BoxNewExp*>(e)) {
        return "~" + b->valueType; // puntero heap, 8 bytes
    }
    if (dynamic_cast<LambdaExp*>(e)) {
        return "lambda"; // centinela; el codegen detecta el nodo, no usa este tipo
    }
    if (FcallExp* fc = dynamic_cast<FcallExp*>(e)) {
        // Heurística para funciones genéricas que retornan su parámetro de tipo:
        // turbofish -> primer typeArg; si no, se infiere del primer argumento.
        if (!fc->typeArgs.empty()) return fc->typeArgs.front();
        if (!fc->argumentos.empty()) return inferTypeFromExp(fc->argumentos.front());
        throw runtime_error("No se puede inferir el tipo del retorno de '" + fc->nombre +
            "'; anote el tipo del let");
    }
    if (ArrayRepeatExp* a = dynamic_cast<ArrayRepeatExp*>(e)) {
        string inner = inferTypeFromExp(a->value);   // "i32" o "i32[3]"
        string sz = "[" + to_string(a->count) + "]";
        size_t br = inner.find('[');
        if (br == string::npos) return inner + sz;
        return inner.substr(0, br) + sz + inner.substr(br);
    }
    throw runtime_error("No se puede inferir el tipo de la expresión inicial");
}

Program* Parser::parseProgram(bool silent){
    silentMode = silent;
    Program* p = new Program();
    parseItems(p);
    if (!isAtEnd()) throw runtime_error("Error sintáctico: tokens restantes tras parseo");
    if (!silentMode) cout << "Parseo exitoso" << endl;
    return p;
}

void Parser::parseItems(Program* p){
    while(!isAtEnd()){
        if (check(Token::FN)){
            p->fdlist.push_back(parseFunction());
        } else if (check(Token::STRUCT)) {
            p->sdlist.push_back(parseStruct());
        } else if (check(Token::TYPE)) {
            p->talist.push_back(parseTypeAlias());
        } else {
            break;
        }
    }
}

FunDec* Parser::parseFunction(){
    consume(Token::FN, "'fn'");
    consume(Token::IDENTIFIER, "nombre de función");
    string nombre = previous->text;
    // Parámetros de tipo genéricos: fn nombre<T, U>(...)
    vector<string> typeParams;
    if (match(Token::LT)) {
        do {
            consume(Token::IDENTIFIER, "nombre de parámetro de tipo");
            typeParams.push_back(previous->text);
        } while (match(Token::COMMA));
        consume(Token::GT, "'>' en lista de parámetros de tipo");
    }
    consume(Token::LPAREN, "'('");
    // ParamListOpt
    vector<string> paramN;
    vector<string> paramT;
    if (check(Token::IDENTIFIER)){
        // Param: IDENTIFIER ':' Type   (Type via parseTypeName -> soporta &T, *T, T[N])
        do {
            consume(Token::IDENTIFIER, "param nombre");
            string pname = previous->text;
            consume(Token::COLON, ":");
            string ptype = parseTypeName();
            paramN.push_back(pname);
            paramT.push_back(ptype);
        } while (match(Token::COMMA));
    }
    consume(Token::RPAREN, "')'");
    string retType = "void";
    if (match(Token::ARROW)){
        retType = parseTypeName();
    }
    // Block
    BlockStm* bodyBlock = parseBlock();
    FunDec* fd = new FunDec();
    fd->nombre = nombre;
    fd->tipo = retType;
    fd->Nparametros = paramN;
    fd->Tparametros = paramT;
    fd->typeParams = typeParams;
    fd->cuerpo = new Body();
    fd->cuerpo->stmlist.push_back(bodyBlock);
    return fd;
}

StructDec* Parser::parseStruct(){
    consume(Token::STRUCT, "'struct'");
    consume(Token::IDENTIFIER, "nombre de struct");
    string structName = previous->text;
    StructDec* sd = new StructDec(structName);
    consume(Token::LBRACE, "'{' struct");
    // Campos: IDENT ':' Type ';'
    while(check(Token::IDENTIFIER)){
        advance(); // nombre campo
        string fieldName = previous->text;
        consume(Token::COLON, ": en campo struct");
        string fieldType = parseTypeName();
        consume(Token::SEMICOL, "; tras campo");
        sd->fields.push_back({fieldName, fieldType});
    }
    consume(Token::RBRACE, "'}' struct");
    return sd;
}

TypeAlias* Parser::parseTypeAlias(){
    consume(Token::TYPE, "'type'");
    consume(Token::IDENTIFIER, "nombre alias");
    string alias = previous->text;
    consume(Token::ASSIGN, "'=' en alias de tipo");
    string typeName = parseTypeName();
    consume(Token::SEMICOL, "; final alias");
    return new TypeAlias(alias, typeName);
}

BlockStm* Parser::parseBlock(){
    BlockStm* block = new BlockStm();
    consume(Token::LBRACE, "'{' bloque");
    while(!check(Token::RBRACE) && !isAtEnd()){
        Stm* s = parseStatement();
        if (s) block->statements.push_back(s);
    }
    consume(Token::RBRACE, "'}' bloque");
    return block;
}

Stm* Parser::parseStatement(){
    if (check(Token::LET))   return parseVarDecl();
    if (check(Token::IF))    return parseIf();
    if (check(Token::WHILE)) return parseWhile();
    if (check(Token::FOR))   return parseFor();
    if (check(Token::RETURN))return parseReturn();
    if (check(Token::PRINTLN)) return parsePrint();
    if (check(Token::LBRACE)) return parseBlock();
    // ExpressionStmt
    Exp* e = parseExpression();
    if (match(Token::SEMICOL)) return new AssignStm("_", e);
    if (check(Token::RBRACE)) {
        ReturnStm* r = new ReturnStm();
        r->e = e;
        return r;
    }
    throw runtime_error("Error sintáctico: se esperaba ';' o fin de bloque tras expresión");
}

LetStm* Parser::parseVarDecl(){
    consume(Token::LET, "'let'");
    bool mut = match(Token::MUT);
    consume(Token::IDENTIFIER, "nombre variable");
    string varName = previous->text;
    string typeName;
    if (match(Token::COLON)) {
        typeName = parseTypeName();
    }
    Exp* init = nullptr;
    if (match(Token::ASSIGN)) {
        init = parseExpression();
    }
    if (typeName.empty() && init) {
        typeName = inferTypeFromExp(init);
    }
    if (typeName.empty()) {
        throw runtime_error("Se requiere tipo explícito o valor inicial en declaración let");
    }
    consume(Token::SEMICOL, "; final declaración");
    return new LetStm(mut, varName, typeName, init);
}

IfStm* Parser::parseIf(){
    consume(Token::IF, "'if'");
    Exp* cond = nullptr;
    if (match(Token::LPAREN)){
        cond = parseExpression(); consume(Token::RPAREN, ") en if");
    } else {
        bool prev = noStructLit; noStructLit = true;
        cond = parseExpression();
        noStructLit = prev;
    }
    BlockStm* thenB = parseBlock();
    BlockStm* elseB = nullptr;
    if (match(Token::ELSE)) { elseB = parseBlock(); }
    return new IfStm(cond, thenB, elseB);
}

WhileStm* Parser::parseWhile(){
    consume(Token::WHILE, "'while'");
    Exp* cond = nullptr;
    if (match(Token::LPAREN)){
        cond = parseExpression(); consume(Token::RPAREN, ") en while");
    } else {
        bool prev = noStructLit; noStructLit = true;
        cond = parseExpression();
        noStructLit = prev;
    }
    BlockStm* body = parseBlock();
    return new WhileStm(cond, body);
}

ForStm* Parser::parseFor(){
    consume(Token::FOR, "'for'");
    consume(Token::IDENTIFIER, "iterador for");
    string it = previous->text;
    consume(Token::IN, "'in' en for");
    bool prev = noStructLit; noStructLit = true;
    Exp* start = parseExpression();
    consume(Token::DOTDOT, "'..' rango for");
    Exp* end = parseExpression();
    noStructLit = prev;
    BlockStm* body = parseBlock();
    return new ForStm(it, start, end, body);
}

ReturnStm* Parser::parseReturn(){
    consume(Token::RETURN, "'return'");
    ReturnStm* r = new ReturnStm();
    // ExpressionOpt
    if (!check(Token::SEMICOL)) { r->e = parseExpression(); }
    consume(Token::SEMICOL, "; en return");
    return r;
}

PrintStm* Parser::parsePrint(){
    consume(Token::PRINTLN, "'println!'");
    consume(Token::LPAREN, "'(' en println");
    // STRING_LITERAL opcional seguido de , lista de expresiones
    if (check(Token::STRING_LITERAL)) advance();
    Exp* firstExpr = nullptr;
    if (match(Token::COMMA)) {
        // lista de expresiones
        firstExpr = parseExpression();
        while(match(Token::COMMA)) { Exp* e2 = parseExpression(); (void)e2; }
    }
    consume(Token::RPAREN, ") en println");
    consume(Token::SEMICOL, "; en println");
    return new PrintStm(firstExpr);
}

// =====================
// Expresiones
// =====================
Exp* Parser::parseExpression(){ return parseAssignment(); }

Exp* Parser::parseAssignment(){
    Exp* left = parseOr();
    if (match(Token::ASSIGN)){
        Exp* right = parseAssignment();
        return new BinaryExp(left, right, ASSIGN_OP);
    }
    if (match(Token::PLUS_ASSIGN)){
        Exp* right = parseAssignment();
        IdExp* idLeft = dynamic_cast<IdExp*>(left);
        if (idLeft) {
            Exp* copyLeft = new IdExp(idLeft->value);
            Exp* addExp = new BinaryExp(copyLeft, right, PLUS_OP);
            return new BinaryExp(left, addExp, ASSIGN_OP);
        }
        throw runtime_error("Compound assignment += requires identifier on left side");
    }
    if (match(Token::MINUS_ASSIGN)){
        Exp* right = parseAssignment();
        IdExp* idLeft = dynamic_cast<IdExp*>(left);
        if (idLeft) {
            Exp* copyLeft = new IdExp(idLeft->value);
            Exp* subExp = new BinaryExp(copyLeft, right, MINUS_OP);
            return new BinaryExp(left, subExp, ASSIGN_OP);
        }
        throw runtime_error("Compound assignment -= requires identifier on left side");
    }
    return left;
}

Exp* Parser::parseOr(){
    Exp* left = parseAnd();
    while (match(Token::OR)) { Exp* right = parseAnd(); left = new BinaryExp(left, right, AND_OP); }
    return left;
}

Exp* Parser::parseAnd(){
    Exp* left = parseRel();
    while (match(Token::AND)) { Exp* right = parseRel(); left = new BinaryExp(left, right, AND_OP); }
    return left;
}

Exp* Parser::parseRel(){
    Exp* left = parseAdd();
    while (match(Token::EQ) || match(Token::NEQ) || match(Token::LT) || match(Token::GT) || match(Token::LE) || match(Token::GE)) {
        BinaryOp op;
        switch(previous->type){
            case Token::EQ: op = EQ_OP; break;
            case Token::NEQ: op = NEQ_OP; break;
            case Token::LT: op = LT_OP; break;
            case Token::GT: op = GT_OP; break;
            case Token::LE: op = LE_OP; break;
            case Token::GE: op = GE_OP; break;
            default: op = LE_OP; break;
        }
        Exp* right = parseAdd(); 
        left = new BinaryExp(left, right, op); 
    }
    return left;
}

Exp* Parser::parseAdd(){
    Exp* left = parseMul();
    while (match(Token::PLUS) || match(Token::MINUS)) { 
        BinaryOp op = (previous->type == Token::PLUS) ? PLUS_OP : MINUS_OP;
        Exp* right = parseMul(); 
        left = new BinaryExp(left, right, op); 
    }
    return left;
}

Exp* Parser::parseMul(){
    Exp* left = parseCast();
    while (match(Token::MUL) || match(Token::DIV)) {
        BinaryOp op = (previous->type == Token::MUL) ? MUL_OP : DIV_OP;
        Exp* right = parseCast();
        left = new BinaryExp(left, right, op);
    }
    return left;
}

// Cast 'as Tipo': liga más fuerte que * / pero más débil que los unarios (precedencia Rust)
Exp* Parser::parseCast(){
    Exp* e = parseUnary();
    while (match(Token::AS)) {
        if (!matchTypeToken()) throw runtime_error("Tipo esperado tras 'as'");
        e = new CastExp(e, previous->text);
    }
    return e;
}

Exp* Parser::parseUnary(){
    if (match(Token::AMP)) {                      // &expr / &mut expr
        bool isMut = match(Token::MUT);
        return new AddressOfExp(parseUnary(), isMut);
    }
    if (match(Token::MUL)) {                       // *expr (derreferencia)
        return new DerefExp(parseUnary());
    }
    if (match(Token::NOT) || match(Token::MINUS) || match(Token::PLUS)) { Exp* right = parseUnary(); return right; }
    return parsePostfix();
}

Exp* Parser::parsePostfix(){
    Exp* primary = parsePrimary();
    while (true){
        if (match(Token::DOT)) { 
            consume(Token::IDENTIFIER, "identificador tras '.'"); 
            primary = new FieldAccessExp(primary, previous->text);
            continue; 
        }
        if (match(Token::LBRACKET)) {
            bool prev = noStructLit; noStructLit = false;
            Exp* index = parseExpression();
            noStructLit = prev;
            consume(Token::RBRACKET, "] en indexación");
            primary = new ArrayAccessExp(primary, index);
            continue;
        }
        // Turbofish: nombre::<T, ...>(args)
        if (check(Token::COLONCOLON)) {
            IdExp* id = dynamic_cast<IdExp*>(primary);
            if (!id) throw runtime_error("Turbofish requiere identificador de función");
            string funcName = id->value;
            advance(); // ::
            consume(Token::LT, "'<' en turbofish");
            vector<string> typeArgs;
            do {
                typeArgs.push_back(parseTypeName());
            } while (match(Token::COMMA));
            consume(Token::GT, "'>' en turbofish");
            consume(Token::LPAREN, "'(' tras turbofish");
            delete primary;
            FcallExp* fcall = new FcallExp();
            fcall->nombre = funcName;
            fcall->typeArgs = typeArgs;
            if (!check(Token::RPAREN)) {
                bool prev = noStructLit; noStructLit = false;
                fcall->argumentos.push_back(parseExpression());
                while(match(Token::COMMA)) fcall->argumentos.push_back(parseExpression());
                noStructLit = prev;
            }
            consume(Token::RPAREN, ") cierre llamada turbofish");
            primary = fcall;
            continue;
        }
        if (match(Token::LPAREN)) {
            FcallExp* fcall = new FcallExp();
            if (IdExp* id = dynamic_cast<IdExp*>(primary)) {
                fcall->nombre = id->value;

            } else {
                throw runtime_error("Llamada a función requiere identificador");
            }
            
            string funcName = ((IdExp*)primary)->value;
            delete primary;
            fcall->nombre = funcName;

            if (!check(Token::RPAREN)) {
                bool prev = noStructLit; noStructLit = false;
                fcall->argumentos.push_back(parseExpression());
                while(match(Token::COMMA)) {
                    fcall->argumentos.push_back(parseExpression());
                }
                noStructLit = prev;
            }
            consume(Token::RPAREN, ") cierre llamada");
            primary = fcall;
            continue;
        }
        if (!noStructLit && check(Token::LBRACE)) {
            if (IdExp* id = dynamic_cast<IdExp*>(primary)) {
                advance(); // Consume LBRACE
                StructInitExp* sinit = new StructInitExp("");
                sinit->name = id->value;
                delete primary;
                
                // Parse fields: ident : expr , ...
                if (!check(Token::RBRACE)) {
                    bool prev = noStructLit; noStructLit = false;
                    do {
                        consume(Token::IDENTIFIER, "nombre campo struct");
                        string fieldName = previous->text;
                        consume(Token::COLON, ": en campo struct");
                        Exp* val = parseExpression();
                        sinit->fields.push_back({fieldName, val});
                    } while(match(Token::COMMA));
                    noStructLit = prev;
                }
                consume(Token::RBRACE, "} cierre struct init");
                primary = sinit;
                continue;
            }
            
        }
        break;
    }
    return primary;
}

Exp* Parser::parsePrimary(){
    // Lambda: |params| body   o   || body  (cero parámetros)
    if (check(Token::PIPE) || check(Token::OR)) {
        vector<pair<string,string>> params;
        if (match(Token::OR)) {
            // '||' = lista de parámetros vacía
        } else {
            advance(); // '|'
            if (!check(Token::PIPE)) {
                do {
                    consume(Token::IDENTIFIER, "nombre de parámetro de lambda");
                    string pname = previous->text;
                    string ptype = "i32"; // tipo por defecto
                    if (match(Token::COLON)) ptype = parseTypeName();
                    params.push_back({pname, ptype});
                } while (match(Token::COMMA));
            }
            consume(Token::PIPE, "'|' de cierre de parámetros de lambda");
        }
        Exp* body = parseExpression();
        LambdaExp* lam = new LambdaExp(body);
        lam->params = params;
        return lam;
    }
    if (match(Token::NUMBER)) {
        string text = previous->text;
        if (text.find('.') != string::npos) {
            return new FloatExp(stod(text), true);
        }
        return new NumberExp(stoll(text));
    }
    if (match(Token::TRUE)) { BoolExp* b = new BoolExp(); b->valor = 1; return b; }
    if (match(Token::FALSE)) { BoolExp* b = new BoolExp(); b->valor = 0; return b; }
    if (match(Token::STRING_LITERAL)) {
        string raw = previous->text;
        if (raw.size() >= 2) raw = raw.substr(1, raw.size() - 2);
        return new StringExp(raw);
    }
    // Box::new(expr)  ->  asignación en heap
    if (check(Token::IDENTIFIER) && current->text == "Box") {
        advance(); // Box
        consume(Token::COLONCOLON, "'::' tras Box");
        consume(Token::IDENTIFIER, "'new' tras Box::");
        if (previous->text != "new") throw runtime_error("Solo se soporta Box::new");
        consume(Token::LPAREN, "'(' en Box::new");
        bool prev = noStructLit; noStructLit = false;
        Exp* v = parseExpression();
        noStructLit = prev;
        consume(Token::RPAREN, "')' en Box::new");
        string vt;
        try { vt = inferTypeFromExp(v); } catch (...) { vt = "i32"; }
        return new BoxNewExp(v, vt);
    }
    if (match(Token::IDENTIFIER)) {
        string name = previous->text;
        return new IdExp(name);
    }
    if (match(Token::LPAREN)) {
        bool prev = noStructLit; noStructLit = false;
        Exp* e = parseExpression();
        noStructLit = prev;
        consume(Token::RPAREN, ") cierre");
        return e;
    }
    if (match(Token::LBRACKET)) {
        // Literal de arreglo repetido: [ valor ; N ]
        bool prev = noStructLit; noStructLit = false;
        Exp* value = parseExpression();
        noStructLit = prev;
        consume(Token::SEMICOL, "; en literal de array");
        consume(Token::NUMBER, "tamaño en literal de array");
        int count = stoi(previous->text);
        consume(Token::RBRACKET, "] en literal de array");
        return new ArrayRepeatExp(value, count);
    }
    throw runtime_error("Expresión primaria inesperada");
}
