#include <iostream>
#include <string>

#include "Compiler.h"
#include "CompilerError.h"

CompilerError compile(const std::string& srcDir, const std::string& outDir)
{
    std::cout << "Compiling " << srcDir << " into " << outDir << "\n";
    return CompilerError(CompilerError::NO_ERROR, "Should not appear");
}
