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

[:space:]*

[:alpha:]+[:alnum:]* {
    yylval->idVal = new AST_IdentifierValue(yytext);
    return IDENTIFIER;
}

true {
    yylval->boolVal = new AST_BoolValue(true);
    return BOOL;
}

false {
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

. {
    std::cerr << "Invalid token on line " << yylineno 
              << ": " << yytext << std::endl;
}

<<EOF>> {
    return 0;
}

%%

AST* parse(const char* srcText) {
    AST* result;

    yyscan_t scanner;
    yylex_init(&scanner);
    YY_BUFFER_STATE buf;
    buf = yy_scan_string(srcText, scanner);

    yyparse(&result, scanner);

    yy_delete_buffer(buf, scanner);
    yylex_destroy(scanner);

    return result;
}
