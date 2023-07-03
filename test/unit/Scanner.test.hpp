#include <iostream>
#include <vector>
#include <functional>

#include "Testing.hpp"

#include <compiler/parser/Parser.hpp>
#include <compiler/scanner/Scanner.hpp>

YY_BUFFER_STATE activeBuffer;

yyscan_t setupScanner(std::string input) {
    yyscan_t scanner;
    yylex_init(&scanner);
    
    activeBuffer = yy_scan_string(input.c_str(), scanner);
    yy_switch_to_buffer(activeBuffer, scanner);

    return scanner;
}

void cleanupScanner(yyscan_t scanner) {
    yy_delete_buffer(activeBuffer, scanner);
}

bool test1() {
    std::cerr << "Gives 0 on empty input";
    
    yyscan_t scanner = setupScanner("");

    YYSTYPE val;
    int result = yylex(&val, scanner);
   
    cleanupScanner(scanner);

    return result == 0;
}

bool test2() {
    std::cerr << "Recognizes an example of each token\n";

    auto testToken = [](std::string input, int expectedToken){
        yyscan_t scanner = setupScanner(input);
        YYSTYPE val;
        int outToken = yylex(&val, scanner);
        cleanupScanner(scanner);

        bool result = outToken == expectedToken;

        std::cerr << "\t" << input << " - " 
                  << (result ? "Passed" : "Failed")
                  << std::endl;

        return outToken == expectedToken;
    };

    return testToken("true", BOOL)
        && testToken("false", BOOL)
        && testToken("return", RETURN)
        && testToken("0123456789", INTEGER)
        && testToken("3.14", FLOAT)
        && testToken("\"hello world\"", STRING)
        && testToken(";", SEMICOLON)
        && testToken("--", FUNCTIONDEC)
        && testToken("&&", AND)
        && testToken("||", OR)
        && testToken("!", NOT)
        && testToken("+", ADD)
        && testToken("-", SUBTRACT)
        && testToken("*", MULTIPLY)
        && testToken("/", DIVIDE)
        && testToken("==", EQUALS)
        && testToken("!=", NOTEQUALS)
        && testToken("(", LPAREN)
        && testToken(")", RPAREN)
        && testToken("Identifier", IDENTIFIER);
}

TestSuite getScannerTestSuite() {
    TestSuite suite;
    suite.name = "Scanner";

    #define TEST(X) suite.tests.push_back(X)
    TEST(test1);
    TEST(test2);

    return suite;
}
