%{

#include <iostream>
#include <stdlib.h>

#include "../parser/Parser.hpp"

%}

%option reentrant
%option bison-bridge

%option noyywrap
%option yylineno

%%

[[:space:]]*

"true" {
    yylval->boolVal = new AST_BoolValue(true);
    return BOOL;
}

"false" {
    yylval->boolVal = new AST_BoolValue(false);
    return BOOL;
}

[0-9]+ {
    yylval->intVal = new AST_IntegerValue(atoi(yytext));
    return INTEGER;
}

[0-9]+"."[0-9]* {
    yylval->floatVal = new AST_FloatValue(atof(yytext));
    return FLOAT;
}

\"[^\"]*\" {
    yylval->strVal = new AST_StringValue(yytext);
    return STRING;
}

";" return yylval->category = SEMICOLON;
"--" return yylval->category = FUNCTIONDEC;

"&&" return yylval->category = AND;
"||" return yylval->category = OR;
"!" return yylval->category = NOT;

"+" return yylval->category = ADD;
"-" return yylval->category = SUBTRACT;
"*" return yylval->category = MULTIPLY;
"/" return yylval->category = DIVIDE;

"==" return yylval->category = EQUALS;
"!=" return yylval->category = NOTEQUALS;

"(" return yylval->category = LPAREN;
")" return yylval->category = RPAREN;

[[:alpha:]][[:alnum:]]* {
    yylval->idVal = new AST_IdentifierValue(yytext);
    return IDENTIFIER;
}

. {
    std::cerr << "Invalid token on line " << yylineno 
              << ": " << yytext << std::endl;
}

<<EOF>> {
    return 0;
}

%%

AST* parse(const char* srcPath) {

    FILE* srcFile = fopen(srcPath, "r");
    if (!srcFile) {
        std::cerr << "Failed to open source file: " 
                  << srcPath << std::endl;
        return nullptr;
    }

    AST* result;

    yyscan_t scanner;
    yylex_init(&scanner);
    
    YY_BUFFER_STATE buf;
    buf = yy_create_buffer(srcFile, YY_BUF_SIZE, scanner);
    yy_switch_to_buffer(buf, scanner);

    yyparse(&result, scanner);

    yy_delete_buffer(buf, scanner);
    yylex_destroy(scanner);

    fclose(srcFile);

    return result;
}
