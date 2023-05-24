%{
#include <iostream>

void yyerror(const char* error);

extern int yylex;
%}

%union {
    int category;
    int intVal;
    float floatVal;
    bool boolVal;
    char* strVal;
}

%token <strVal> IDENTIFIER;
%token <intVal> INTEGER;
%token <floatVal> FLOAT;
%token <boolVal> BOOL;
%token <strVal> STRING;

%token <category> ADD SUBTRACT MULTIPLY DIVIDE
%token <category> AND OR NOT EQUALS NOTEQUALS
%token <category> SEMICOLON LPAREN RPAREN
%token <category> FUNCTIONDEC

%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%type <boolVal> boolExpression
%type <intVal> integerExpression
%type <floatVal> floatExpression
%type <strVal> stringExpression

%start functionBody

%%

functionBody
    : functionBody statement
    | statement
    ;

statement
    : bindStatement
    | functionCallStatement
    | functionDeclareStatement
    ;

bindStatement
    : IDENTIFIER EQUALS expression SEMICOLON
    ;

functionCallStatement
    : IDENTIFIER args SEMICOLON
    ;

functionDeclareStatement
    : IDENTIFIER FUNCTIONDEC functionBody SEMICOLON
    ;

args
    : args arg
    | arg
    ;

arg
    : IDENTIFIER | expression
    ;

expression
    : LPAREN expression RPAREN
    | boolExpression
    | integerExpression
    | floatExpression
    | stringExpression
    | BOOL
    | INTEGER
    | FLOAT
    | STRING
    ;
    
boolExpression
    : BOOL
    | boolExpression AND boolExpression
    | boolExpression OR boolExpression
    | NOT boolExpression 
    ;

integerExpression
    : INTEGER
    | integerExpression ADD integerExpression
    | integerExpression SUBTRACT integerExpression
    | integerExpression MULTIPLY integerExpression
    | integerExpression DIVIDE integerExpression
    ;

floatExpression
    : FLOAT
    | floatExpression ADD floatExpression
    | floatExpression SUBTRACT floatExpression
    | floatExpression MULTIPLY floatExpression
    | floatExpression DIVIDE floatExpression
    ;

stringExpression
    : STRING
    | stringExpression ADD stringExpression
    ;

%%

void yyerror(const char* error)
{
    fprintf(stderr, "Error: %s\n", error);
}
