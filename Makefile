CPPFILES = \
	$(wildcard src/*.cpp) \
	$(wildcard src/compiler/*.cpp)

OBJFILES = $(addprefix build/, $(CPPFILES:.cpp=.o))
OUT = build/Cry
CFLAGS = -g -Wall -Wextra -Wpedantic -Werror
LDLIBS = -lstdc++

.PHONY: all
all: $(OUT)

$(OUT): $(OBJFILES)
	g++ -o $@ $^

build/%.o: %.cpp
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -f $(OBJFILES) $(OUT)

