#include <iostream>
#include <fstream>
#include <string>

#include "Compiler.h"
#include "CompilerError.h"

#include "codegen/AST.h"

extern AST* parse(const char* srcText);

void writeGraphVis(AST* ast, const std::string& outDir) {
    std::ofstream outFile;
    outFile.open(outDir);
    outFile << ast->genGraphVis();
    outFile.close(); 
}

CompilerError compile(const std::string& srcDir, const std::string& outDir)
{
    std::cout << "Compiling " << srcDir << " into " << outDir << "\n";
    
    AST* ast = parse(srcDir.c_str());
    if (!ast) {
        return CompilerError(CompilerError::PARSING_ERROR, "Parse Failed");
    }

    std::cout << "Parse successful" << std::endl;

    writeGraphVis(ast, outDir);
    
    return CompilerError(CompilerError::NO_ERROR, "Should not appear");
}
