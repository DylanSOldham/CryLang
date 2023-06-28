%{%}
%define api.pure full
%define parse.error verbose
%define parse.trace

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
    std::vector<AST_IdentifierValue*>* idListVal;
}

%token <idVal> IDENTIFIER;
%token <intVal> INTEGER;
%token <floatVal> FLOAT;
%token <boolVal> BOOL;
%token <strVal> STRING;

%token <category> ADD SUBTRACT MULTIPLY DIVIDE
%token <category> AND OR NOT EQUALS NOTEQUALS
%token <category> RETURN SEMICOLON LPAREN RPAREN
%token <category> FUNCTIONDEC

%left AND OR NOT EQUALS NOTEQUALS
%left ADD SUBTRACT
%left MULTIPLY DIVIDE
%right IDENTIFIER LPAREN INTEGER FLOAT BOOL STRING

%type<astVal> program
%type<functionBodyVal> functionBody
%type<statementVal> returnStatement;
%type<statementVal> functionDeclareStatement
%type<statementVal> functionCallStatement
%type<statementVal> bindStatement
%type<statementVal> statement
%type<exprVal> expression 
%type<valueVal> value
%type<idListVal> idList
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
      }
    ;

functionBody
    : functionBody statement { 
        $1->statements->push_back($2);
        $$ = $1;
      }
    | %empty { 
        AST_FunctionBody* body = new AST_FunctionBody();
        body->statements = new std::vector<AST_Statement*>();
        $$ = body;
      }
    ;

statement
    : bindStatement
    | functionCallStatement
    | functionDeclareStatement
    | returnStatement
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
    : IDENTIFIER idList FUNCTIONDEC functionBody SEMICOLON {
        auto v = new AST_FunctionDeclareStatement();
        v->functionName = $1;
        v->params = $2;
        v->functionBody = $4;
        $$ = v;
      }
    ;

returnStatement
    : RETURN expression SEMICOLON {
        auto v = new AST_ReturnStatement();
        v->value = $2;
        $$ = v;
    }

idList
    : idList IDENTIFIER {
        $1->push_back($2);
      }
    | %empty {
        $$ = new std::vector<AST_IdentifierValue*>();
      }
    ;

args
    : args expression {
        $1->push_back($2);
        $$ = $1;
      }
    | idList %prec IDENTIFIER {
        $$ = new std::vector<AST_Expression*>();
        for (auto v : *$1) {
            $$->push_back(v);
        }  
      }
    ;

expression
    : LPAREN expression RPAREN {$$ = $2;}
    | value 
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
