SCANDIR = src/compiler/scanner
PARSEDIR = src/compiler/parser
CODEGENDIR = src/compiler/codegen

CPPFILES = \
	$(wildcard src/*.cpp) \
	$(wildcard src/compiler/*.cpp) \
	$(SCANDIR)/Scanner.cpp \
	$(PARSEDIR)/Parser.cpp \
    $(wildcard src/compiler/codegen/*.cpp)	

OBJFILES = $(addprefix build/, $(CPPFILES:.cpp=.o))
OUT = build/Cry
CFLAGS = -g -Wall -Wextra -Wpedantic -Werror -Wno-unused-function
LDLIBS = -lstdc++

.PHONY: all
all: $(OUT) test

$(OUT): $(OBJFILES)
	g++ -o $@ $^

$(SCANDIR)/Scanner.cpp: $(SCANDIR)/Scanner.l $(PARSEDIR)/Parser.hpp
	flex --header-file=$(SCANDIR)/Scanner.hpp -o $(SCANDIR)/Scanner.cpp $(SCANDIR)/Scanner.l

$(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.hpp: $(PARSEDIR)/Parser.y
	bison -Wcex -d -o $(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.y

build/%.o: %.cpp
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) -o $@ $<



TESTFILES = test/unit/Testing.cpp \
			test/unit/Testing.hpp \
		    test/unit/Scanner.test.hpp

.PHONY: test
test: $(TESTFILES)
	g++ -o build/test $(TESTFILES) \
		build/$(SCANDIR)/Scanner.o \
		build/$(PARSEDIR)/Parser.o \
		build/$(CODEGENDIR)/AST.o \
		-I src



.PHONY: clean
clean:
	rm -rf build/* \
		$(SCANDIR)/Scanner.cpp \
		$(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.hpp

