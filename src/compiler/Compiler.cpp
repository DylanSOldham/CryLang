#include <iostream>
#include <string>

#include "Compiler.h"
#include "CompilerError.h"

#include "parser/AST.h"

extern AST* parse(const char* srcText);

CompilerError compile(const std::string& srcDir, const std::string& outDir)
{
    std::cout << "Compiling " << srcDir << " into " << outDir << "\n";
    
    AST* ast = parse("main -- print 1;");
    if (!ast) {
        return CompilerError(CompilerError::PARSING_ERROR, "Parse Failed");
    }

    return CompilerError(CompilerError::NO_ERROR, "Should not appear");
}
