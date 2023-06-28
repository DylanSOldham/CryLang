/* A Bison parser, made by GNU Bison 3.8.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_SRC_COMPILER_PARSER_PARSER_HPP_INCLUDED
# define YY_YY_SRC_COMPILER_PARSER_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 50 "src/compiler/parser/Parser.y"

    #include <iostream>
    #include "../codegen/AST.h"

    typedef void* yyscan_t;

    void yyerror(AST** result, yyscan_t scanner, const char* error);

#line 58 "src/compiler/parser/Parser.hpp"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IDENTIFIER = 258,              /* IDENTIFIER  */
    INTEGER = 259,                 /* INTEGER  */
    FLOAT = 260,                   /* FLOAT  */
    BOOL = 261,                    /* BOOL  */
    STRING = 262,                  /* STRING  */
    ADD = 263,                     /* ADD  */
    SUBTRACT = 264,                /* SUBTRACT  */
    MULTIPLY = 265,                /* MULTIPLY  */
    DIVIDE = 266,                  /* DIVIDE  */
    AND = 267,                     /* AND  */
    OR = 268,                      /* OR  */
    NOT = 269,                     /* NOT  */
    EQUALS = 270,                  /* EQUALS  */
    NOTEQUALS = 271,               /* NOTEQUALS  */
    RETURN = 272,                  /* RETURN  */
    SEMICOLON = 273,               /* SEMICOLON  */
    LPAREN = 274,                  /* LPAREN  */
    RPAREN = 275,                  /* RPAREN  */
    FUNCTIONDEC = 276              /* FUNCTIONDEC  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 6 "src/compiler/parser/Parser.y"

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

#line 112 "src/compiler/parser/Parser.hpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif




int yyparse (AST** result, yyscan_t scanner);


#endif /* !YY_YY_SRC_COMPILER_PARSER_PARSER_HPP_INCLUDED  */
