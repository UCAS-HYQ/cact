#include <iostream>
#include <fstream>
#include <string>
#include <exception>

#include "antlr4-runtime.h"
#include "CACTLexer.h"
#include "CACTParser.h"

using namespace antlr4;

class CountingErrorListener : public BaseErrorListener {
public:
    int errors = 0;

    void syntaxError(Recognizer *, Token *, size_t line, size_t charPositionInLine,
                     const std::string &msg, std::exception_ptr) override {
        ++errors;
        std::cerr << "line " << line << ":" << charPositionInLine << " " << msg << std::endl;
    }
};

int main(int argc, const char *argv[]) {
    if (argc < 2) {
        std::cerr << "usage: " << argv[0] << " <source.cact>" << std::endl;
        return 2;
    }

    std::ifstream stream(argv[1]);
    if (!stream.is_open()) {
        std::cerr << "Failed to open file: " << argv[1] << std::endl;
        return 2;
    }

    ANTLRInputStream input(stream);
    CACTLexer lexer(&input);
    CommonTokenStream tokens(&lexer);
    CACTParser parser(&tokens);

    lexer.removeErrorListeners();
    parser.removeErrorListeners();

    CountingErrorListener listener;
    lexer.addErrorListener(&listener);
    parser.addErrorListener(&listener);

    parser.compUnit();

    return listener.errors == 0 ? 0 : 1;
}
