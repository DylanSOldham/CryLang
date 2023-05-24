PARSEDIR = src/compiler/parser

CPPFILES = \
	$(wildcard src/*.cpp) \
	$(wildcard src/compiler/*.cpp) \
	src/compiler/parser/parser.cpp

OBJFILES = $(addprefix build/, $(CPPFILES:.cpp=.o))
OUT = build/Cry
CFLAGS = -g -Wall -Wextra -Wpedantic -Werror
LDLIBS = -lstdc++

.PHONY: all
all: $(OUT)

$(OUT): $(OBJFILES)
	g++ -o $@ $^

$(PARSEDIR)/parser.cpp: $(PARSEDIR)/parser.y
	bison -d -o $(PARSEDIR)/parser.cpp $(PARSEDIR)/parser.y

build/%.o: %.cpp
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -f $(OBJFILES) $(OUT) $(PARSEDIR)/parser.cpp

