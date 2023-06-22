SCANDIR = src/compiler/scanner
PARSEDIR = src/compiler/parser

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
all: $(OUT)

$(OUT): $(OBJFILES)
	g++ -o $@ $^

$(SCANDIR)/Scanner.cpp: $(SCANDIR)/Scanner.l $(PARSEDIR)/Parser.hpp
	flex --header-file=$(SCANDIR)/Scanner.hpp -o $(SCANDIR)/Scanner.cpp $(SCANDIR)/Scanner.l

$(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.hpp: $(PARSEDIR)/Parser.y
	bison -d -o $(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.y

build/%.o: %.cpp
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -f $(OBJFILES) $(OUT) \
		$(SCANDIR)/Scanner.cpp \
		$(PARSEDIR)/Parser.cpp $(PARSEDIR)/Parser.hpp

