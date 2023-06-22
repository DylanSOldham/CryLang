%{%}
%define api.pure full
%define parse.error verbose

%union {
    int category;
    AST_IdentifierValue* idVal;
    AST_IntegerValue* intVal;
    AST_FloatValue* floatVal;
    AST_BoolValue* boolVal;
    AST_StringValue* strVal;
    AST* astVal;
    AST_FunctionBody* functionBodyVal;
    AST_Statement* statementVal;
    AST_Expression* exprVal;
    AST_Value* valueVal;
    std::vector<AST_Expression*>* argsVal;
    std::vector<AST_IdentifierValue*>* paramsVal;
}

%token <idVal> IDENTIFIER;
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

%type<astVal> program
%type<functionBodyVal> functionBody
%type<statementVal> functionDeclareStatement
%type<statementVal> functionCallStatement
%type<statementVal> bindStatement
%type<statementVal> statement
%type<exprVal> expression 
%type<valueVal> value
%type<paramsVal> params
%type<argsVal> args

%code requires {
    #include <iostream>
    #include "../codegen/AST.h"

    typedef void* yyscan_t;

    void yyerror(AST** result, yyscan_t scanner, const char* error);
}

%code {
    extern int yylex(YYSTYPE* yylval_param, yyscan_t scanner);
    extern void setupScan(const char* srcText);
} 

%lex-param {yyscan_t scanner}
%parse-param {AST** result}
%parse-param {yyscan_t scanner}

%start program

%%

program
    : functionBody {
        *result = new AST();
        (*result)->body = $1;
        $$ = *result;
        return 0; 
      }
    ;

functionBody
    : statement { 
        AST_FunctionBody* body = new AST_FunctionBody();
        body->statements = new std::vector<AST_Statement*>();
        body->statements->push_back($1);
        $$ = body;
      }
    | functionBody statement { 
        $1->statements->push_back($2);
        $$ = $1;
      }
    ;

statement
    : bindStatement
    | functionCallStatement
    | functionDeclareStatement
    ;

bindStatement
    : IDENTIFIER EQUALS expression SEMICOLON {
        AST_BindStatement* bindStatement = new AST_BindStatement();
        bindStatement->lhs = $1;
        bindStatement->rhs = $3;
        $$ = bindStatement;
      }
    ;

functionCallStatement
    : IDENTIFIER args SEMICOLON {
        auto v = new AST_FunctionCallStatement();
        v->functionName = $1;
        v->args = $2;
        $$ = v;
      }
    ;

functionDeclareStatement
    : IDENTIFIER params FUNCTIONDEC functionBody SEMICOLON {
        auto v = new AST_FunctionDeclareStatement();
        v->functionName = $1;
        v->params = $2;
        v->functionBody = $4;
        $$ = v;
      }
    | IDENTIFIER FUNCTIONDEC functionBody SEMICOLON {
        auto v = new AST_FunctionDeclareStatement();
        v->functionName = $1;
        v->params = new std::vector<AST_IdentifierValue*>();
        v->functionBody = $3;
        $$ = v;
      }
    ;

args
    : args expression {
        $1->push_back($2);
        $$ = $1;
      }
    | expression {
        auto v = new std::vector<AST_Expression*>();
        v->push_back($1);
        $$ = v;
      }
    ;

params
    : params IDENTIFIER {
        $1->push_back($2);
        $$ = $1;
      }
    | IDENTIFIER {
        $$ = new std::vector<AST_IdentifierValue*>();
      }
    ;

expression
    : LPAREN expression RPAREN {$$ = $2;}
    | value {
        $$ = $1;
      } 
    | expression AND expression {
        auto v = new AST_AndExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression OR expression {
        auto v = new AST_OrExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression EQUALS expression {
        auto v = new AST_EqualsExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression NOTEQUALS expression {
        auto v = new AST_NotEqualsExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | NOT expression {
        auto v = new AST_NotExpression();
        v->negated = $2;
        $$ = v;
      } 
    | expression ADD expression {
        auto v = new AST_AddExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression SUBTRACT expression {
        auto v = new AST_SubtractExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression MULTIPLY expression {
        auto v = new AST_MultiplyExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    | expression DIVIDE expression {
        auto v = new AST_AddExpression();
        v->lhs = $1;
        v->rhs = $3;
        $$ = v;
      }
    ;

value
    : IDENTIFIER
    | BOOL 
    | INTEGER
    | FLOAT 
    | STRING 
    ;

%%

void yyerror(AST** result, yyscan_t scanner, const char* error)
{
    if (!result) {
        fprintf(stderr, "%08lx Failed to produce result", 
            (long unsigned int) scanner
        );
    }

    fprintf(stderr, "Error: %s\n", error);
}
