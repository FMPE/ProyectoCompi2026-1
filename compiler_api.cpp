#include "compiler_api.h"
#include "scanner.h"
#include "parser.h"
#include "ast.h"
#include "visitor.h"
#include "ast_json.h"
#include "json_utils.h"
#include "token.h"

#include <sstream>
#include <fstream>

using namespace std;

static string tokenTypeName(Token::Type t) {
    switch (t) {
        case Token::NUMBER: return "NUMBER";
        case Token::STRING_LITERAL: return "STRING_LITERAL";
        case Token::IDENTIFIER: return "IDENTIFIER";
        case Token::ERR: return "ERR";
        case Token::END: return "END";
        case Token::LPAREN: return "LPAREN";
        case Token::RPAREN: return "RPAREN";
        case Token::LBRACE: return "LBRACE";
        case Token::RBRACE: return "RBRACE";
        case Token::LBRACKET: return "LBRACKET";
        case Token::RBRACKET: return "RBRACKET";
        case Token::COMMA: return "COMMA";
        case Token::SEMICOL: return "SEMICOL";
        case Token::COLON: return "COLON";
        case Token::DOT: return "DOT";
        case Token::DOTDOT: return "DOTDOT";
        case Token::ARROW: return "ARROW";
        case Token::PLUS: return "PLUS";
        case Token::MINUS: return "MINUS";
        case Token::MUL: return "MUL";
        case Token::DIV: return "DIV";
        case Token::MOD: return "MOD";
        case Token::POW: return "POW";
        case Token::ASSIGN: return "ASSIGN";
        case Token::PLUS_ASSIGN: return "PLUS_ASSIGN";
        case Token::MINUS_ASSIGN: return "MINUS_ASSIGN";
        case Token::OR: return "OR";
        case Token::AND: return "AND";
        case Token::NOT: return "NOT";
        case Token::EQ: return "EQ";
        case Token::NEQ: return "NEQ";
        case Token::LT: return "LT";
        case Token::GT: return "GT";
        case Token::LE: return "LE";
        case Token::GE: return "GE";
        case Token::FN: return "FN";
        case Token::STRUCT: return "STRUCT";
        case Token::TYPE: return "TYPE";
        case Token::LET: return "LET";
        case Token::MUT: return "MUT";
        case Token::FOR: return "FOR";
        case Token::IN: return "IN";
        case Token::IF: return "IF";
        case Token::ELSE: return "ELSE";
        case Token::WHILE: return "WHILE";
        case Token::RETURN: return "RETURN";
        case Token::PRINTLN: return "PRINTLN";
        case Token::TRUE: return "TRUE";
        case Token::FALSE: return "FALSE";
        case Token::STRING: return "STRING";
        case Token::U8: return "U8";
        case Token::U16: return "U16";
        case Token::U32: return "U32";
        case Token::U64: return "U64";
        case Token::USIZE: return "USIZE";
        case Token::I32: return "I32";
        case Token::I64: return "I64";
        case Token::F32: return "F32";
        case Token::F64: return "F64";
        case Token::BOOL: return "BOOL";
        default: return "UNKNOWN";
    }
}

static string tokenizeToJson(const string& source) {
    Scanner scanner(source.c_str());
    ostringstream json;
    json << "[";
    bool first = true;
    while (true) {
        Token* tok = scanner.nextToken();
        if (!first) json << ",";
        first = false;
        json << "{\"type\":" << jsonString(tokenTypeName(tok->type))
             << ",\"text\":" << jsonString(tok->text) << "}";
        if (tok->type == Token::END) { delete tok; break; }
        delete tok;
    }
    json << "]";
    return json.str();
}

CompileResult compileSource(const string& source, bool enableOptimizations) {
    CompileResult result;
    try {
        result.tokensJson = tokenizeToJson(source);

        Scanner scanner(source.c_str());
        Parser parser(&scanner);
        Program* program = parser.parseProgram(true);

        ASTJsonVisitor astPrinter;
        result.astJson = astPrinter.exportProgram(program);

        ostringstream asmStream;
        GenCodeVisitor codegen(asmStream);
        codegen.enableOptimizations(enableOptimizations);
        codegen.enableDAGOptimization(enableOptimizations);
        codegen.enablePeepholeOptimization(enableOptimizations);
        codegen.generar(program);

        result.assembly = asmStream.str();
        auto stats = codegen.getOptimizationStats();
        result.originalInstructions = stats.originalInstructions;
        result.optimizedInstructions = stats.optimizedInstructions;
        result.peepholeReductions = stats.peepholeReductions;
        result.dagHits = codegen.getDAGHits();
        result.success = true;

        delete program;
    } catch (const exception& ex) {
        result.success = false;
        result.error = ex.what();
    }
    return result;
}

string compileResultToJson(const CompileResult& r) {
    ostringstream json;
    json << "{";
    json << "\"success\":" << (r.success ? "true" : "false") << ",";
    json << "\"error\":" << (r.error.empty() ? "null" : jsonString(r.error)) << ",";
    json << "\"tokens\":" << (r.tokensJson.empty() ? "[]" : r.tokensJson) << ",";
    json << "\"ast\":" << (r.astJson.empty() ? "null" : r.astJson) << ",";
    json << "\"assembly\":" << jsonString(r.assembly) << ",";
    json << "\"stats\":{";
    json << "\"originalInstructions\":" << r.originalInstructions << ",";
    json << "\"optimizedInstructions\":" << r.optimizedInstructions << ",";
    json << "\"dagHits\":" << r.dagHits << ",";
    json << "\"peepholeReductions\":" << r.peepholeReductions;
    if (r.originalInstructions > 0) {
        int saved = r.originalInstructions - r.optimizedInstructions;
        int pct = (saved * 100) / r.originalInstructions;
        json << ",\"reductionPercent\":" << pct;
    } else {
        json << ",\"reductionPercent\":0";
    }
    json << "}}";
    return json.str();
}
