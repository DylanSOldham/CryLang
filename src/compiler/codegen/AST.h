#pragma once

#include <iostream>
#include <vector>
#include <string>
#include <sstream>

class AST_FunctionBody;

struct AST {
public:
    AST_FunctionBody* body;
    static int nodeId;

    std::string genGraphVis();
};

class AST_Node {
public:
    virtual std::string genGraphVis(std::string parent) 
    {
        return parent + " -> Node" 
                + std::to_string(AST::nodeId++);
    }
};

class AST_Expression : public AST_Node {};

class AST_Value : public AST_Expression {};

class AST_IdentifierValue : public AST_Value {
public:	
	std::string identifier;
    AST_IdentifierValue(std::string identifier) 
        : identifier(identifier) {}

    std::string genGraphVis(std::string parent) override;
};

class AST_BoolValue : public AST_Value {
public:	
	bool value;
    AST_BoolValue(bool value) : value(value) {}
};

class AST_IntegerValue : public AST_Value {
public:
	int value;
    AST_IntegerValue(int value) : value(value) {}

    std::string genGraphVis(std::string parent) override;
};

class AST_FloatValue : public AST_Value {
public:
	float value;
    AST_FloatValue(float value) : value(value) {}
};

class AST_StringValue : public AST_Value {
public:
	std::string value;
    AST_StringValue(std::string value) : value(value) {}

    std::string genGraphVis(std::string parent);
};

class AST_AndExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_OrExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_NotExpression : public AST_Expression {
public:
	AST_Expression* negated;
};

class AST_EqualsExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_NotEqualsExpression : public AST_Expression {
public:
    AST_Expression* lhs;
    AST_Expression* rhs;
};

class AST_AddExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_SubtractExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_MultiplyExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_DivideExpression : public AST_Expression {
public:
	AST_Expression* lhs;
	AST_Expression* rhs;
};

class AST_Statement : public AST_Node {
public:
    virtual std::string toString() = 0;
};

class AST_BindStatement : public AST_Statement {
public:
    AST_IdentifierValue* lhs;
    AST_Expression* rhs;

    std::string toString() {return "BindStatement";}
};

class AST_FunctionCallStatement : public AST_Statement {
public:
    AST_IdentifierValue* functionName;
    std::vector<AST_Expression*>* args;

    std::string genGraphVis(std::string parent) override;
    std::string toString() {return "FunctionCallStatement";}
};

class AST_FunctionDeclareStatement : public AST_Statement {
public:
    AST_IdentifierValue* functionName;
    std::vector<AST_IdentifierValue*>* params;
    AST_FunctionBody* functionBody;

    std::string genGraphVis(std::string parent) override;
    std::string toString() {return "FunctionDeclareStatement";}
};

class AST_FunctionBody : AST_Node {
public:
    std::vector<AST_Statement*>* statements;

    std::string genGraphVis(std::string parent) override;
};

