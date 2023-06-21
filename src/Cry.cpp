#include <iostream>
#include <string>

#include "compiler/Compiler.h"

bool validateSrcPath(const std::string& srcDir)
{
    std::string extensionString = ".cry";
    const size_t extensionLength = extensionString.length();
    
    if (srcDir.length() < extensionLength) return false;
    
    bool validExtension = srcDir.compare(
            srcDir.length() - extensionLength,
            extensionLength, extensionString) == 0;

    if (!validExtension)
    {
        return false;
    }

    return true;
}

void runCompilation(const std::string& srcDir, const std::string& outDir)
{
    if (!validateSrcPath(srcDir))
    {
        std::cout << "Not a valid source file: " << srcDir << "\n";
        return;
    }

    CompilerError error = compile(srcDir, outDir);
    if (error.getType() != CompilerError::NO_ERROR)
    {
        std::cout << error.toString() << "\n";
    }
}

int main(int argc, char** argv) 
{   
    if (argc == 2) 
    {
        const std::string srcDir = argv[1];
        const std::string outDir = ".";
        runCompilation(srcDir, outDir);
        return 0;
    }

    std::cout << "Cry: Malformed command syntax\n";
    return -1;
}
