#include <vector>
#include <string>

class AST_FunctionBody;

class AST_Node {
public:
	virtual ~AST_Node() {} // For RTTI
};

class AST_Expression : public AST_Node {};

class AST_Value : public AST_Expression {
public:
	AST_Value* value;
};

class AST_IdentifierValue : public AST_Value {
public:	
	std::string identifier;
    AST_IdentifierValue(std::string identifier) 
        : identifier(identifier) {}
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

class AST_Statement : public AST_Node {};

class AST_BindStatement : public AST_Statement {
public:
    AST_IdentifierValue* lhs;
    AST_Expression* rhs;
};

class AST_FunctionCallStatement : public AST_Statement {
public:
    AST_IdentifierValue* functionName;
    std::vector<AST_Expression*>* args;
};

class AST_FunctionDeclareStatement : public AST_Statement {
public:
    AST_IdentifierValue* functionName;
    std::vector<AST_IdentifierValue*>* params;
    AST_FunctionBody* functionBody;
};

struct AST_FunctionBody {
    std::vector<AST_Statement*> statements;
};

struct AST {
public:
    AST_FunctionBody* body;
};
