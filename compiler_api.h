#ifndef COMPILER_API_H
#define COMPILER_API_H

#include <string>

struct CompileResult {
    bool success = false;
    std::string error;
    std::string tokensJson;
    std::string astJson;
    std::string assembly;
    int originalInstructions = 0;
    int optimizedInstructions = 0;
    int dagHits = 0;
    int peepholeReductions = 0;
};

CompileResult compileSource(const std::string& source, bool enableOptimizations = true);
std::string compileResultToJson(const CompileResult& result);

#endif
