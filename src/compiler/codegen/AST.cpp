#include "AST.h"

std::string AST_IdentifierValue::genGraphVis(std::string parent) 
{
    return parent + " -> " + "IDENTIFIER" + std::to_string(AST::nodeId++)
                  + "_" + identifier + "\n";
}

std::string AST_StringValue::genGraphVis(std::string parent)
{
    std::string nodeName = "\"STRING" + std::to_string(AST::nodeId++)
                         + "_\\" + value;

    value[value.length()-1] = '\\';
    return nodeName + " [label=\"\\" + value + "\"\"]\n" 
         + parent + " -> " + nodeName + "\n";
}

std::string AST_FunctionCallStatement::genGraphVis(std::string parent) 
{
    std::stringstream result;

    std::string nodeName = "FUNCTIONCALL" + std::to_string(AST::nodeId++);

    result << parent << " -> " << nodeName << "\n"
           << functionName->genGraphVis(nodeName);
    for (size_t i = 0; i < args->size(); ++i) 
    {
        result << args->at(i)->genGraphVis(nodeName);
    }

    return result.str();
}

std::string AST_FunctionDeclareStatement::genGraphVis(std::string parent) 
{
    std::stringstream result;

    std::string nodeName = "FUNCTIONDEC" + std::to_string(AST::nodeId++);
   
    result << parent << " -> " << nodeName << "\n";
    result << functionName->genGraphVis(nodeName);
    for (size_t i = 0; i < params->size(); ++i) 
    {
        result << params->at(i)->genGraphVis(nodeName);
    }
    result << functionBody->genGraphVis(nodeName);

    return result.str();
}

std::string AST_FunctionBody::genGraphVis(std::string parent) 
{
    std::stringstream result;

    std::string nodeName = "FUNCTIONBODY" + std::to_string(AST::nodeId++);
    
    result << parent <<  " -> " << nodeName << "\n";

    for (size_t i = 0; i < statements->size(); ++i) 
    {
        result << statements->at(i)->genGraphVis(nodeName)
               << "\n";
    }

    return result.str(); 
}

std::string AST::genGraphVis() 
{
    std::stringstream result;

    result << "digraph G {\n"
        << body->genGraphVis("AST")
        << "}";

    AST::nodeId = 0;

    return result.str();
}

int AST::nodeId = 0;
