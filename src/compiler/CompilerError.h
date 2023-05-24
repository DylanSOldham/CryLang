#pragma once

#include <string>

typedef char CompilerErrorType;

class CompilerError
{
    private:
        const CompilerErrorType type;
        const std::string message;

    public:
        static const CompilerErrorType NO_ERROR = 0;
        static const CompilerErrorType LEXING_ERROR = 1;
        static const CompilerErrorType PARSING_ERROR = 2;
        static const CompilerErrorType CODEGEN_ERROR = 3;

        CompilerError(CompilerErrorType type, std::string message)
            : type(type), message(message)
        {
        }

        CompilerError(const CompilerError& other)
            : type(other.getType()), message(other.getMessage())
        {
        }

        CompilerErrorType getType() const
        {
            return type;
        }

        std::string getMessage() const
        {
            return message;
        }

        std::string toString() const
        {
            std::string typeString;
            switch (type) 
            {
                case NO_ERROR:
                    typeString = "No Error";
                    break;
                case LEXING_ERROR:
                    typeString = "Lexing Error";
                    break;
                case PARSING_ERROR:
                    typeString = "Parsing Error";
                    break;
                case CODEGEN_ERROR:
                    typeString = "Codegen Error";
                    break;
                default:
                    typeString = "Unidentified Error";
                    break;
            }

            return typeString + ": " + message;
        }
};










