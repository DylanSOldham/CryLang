#ifndef TESTING_H
#define TESTING_H

#include <iostream>
#include <string>
#include <vector>
#include <functional>

struct TestSuite {
    std::string name;
    std::vector<std::function<bool()>> tests;
};

bool runTestSuite(const TestSuite& suite) {
    int numTests = 0;
    int numPassed = 0;

    std::cerr << "Running test suite: " << suite.name << "\n";

    for (std::function<bool()> f : suite.tests) {
        numTests++;

        std::string message = "Failed";

        if (f()) {
            message = "Passed";
            numPassed++;
        }

        std::cerr << " - " << message << std::endl;
    }

    std::cerr << "Passed " << numPassed << "/" << numTests
              << "\n\n\n";

    return numPassed == numTests;
}

#endif
