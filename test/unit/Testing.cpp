#include "Testing.hpp"

#include "Scanner.test.hpp"

int main() {

    bool allPassed = runTestSuite(getScannerTestSuite()); 

    if (!allPassed) {
        std::cerr << "Some tests failed" << std::endl;
    } else {
        std::cerr << "All tests passed" << std::endl;
    }

    return 0;
}
