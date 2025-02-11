CXX:=g++
CXXFLAGS:=-Wall -Wextra -Werror -Wpedantic -std=c++17
LDFLAGS:=-Lm -lstdc++fs

incdir=include
srcdir=src
libdir=lib
bindir=bin

args_src=$(wildcard $(srcdir)/args/*.cpp)
args_obj=$(patsubst $(srcdir)/args/%.cpp, $(libdir)/%.o, $(args_src))

logging_src=$(wildcard $(srcdir)/logging/*.cpp)
logging_obj=$(patsubst $(srcdir)/logging/%.cpp, $(libdir)/%.o, $(logging_src))

files_src:=$(wildcard $(srcdir)/files/*.cpp)
files_obj:=$(patsubst $(srcdir)/files/%.cpp, $(libdir)/%.o, $(files_src))

pointers_src:=$(wildcard $(srcdir)/pointers/*.cpp)
pointers_obj:=$(patsubst $(srcdir)/pointers/%.cpp, $(libdir)/%.o, $(pointers_src))

libs:=$(pointers_obj) $(args_obj) $(logging_obj) $(files_obj)

main=$(srcdir)/main.cpp

target=$(bindir)/tarinstall

ifdef DEBUG
	CXXFLAGS+=-g
endif

ifdef EXTRAFLAGS
	CXXFLAGS+=$(EXTRAFLAGS)
endif

ifdef VERBOSE
	rmcmd:=@ rm -vr
	mkdircmd:=@ mkdir -v
else
	CXX:=@ $(CXX)
	rmcmd=@ rm -r
	mkdircmd:=@ mkdir
endif

all: $(libdir) $(bindir) $(target)

$(target): $(main) $(libs)
	$(CXX) -o $@ $^ $(LDFLAGS)
 
$(args_obj): $(args_src)
	$(CXX) -c -o $@ $^ -Iinclude/args $(CXXFLAGS)

$(logging_obj): $(logging_src)
	$(CXX) -c -o $@ $^ -Iinclude/logging $(CXXFLAGS)

$(files_obj): $(files_src)
	$(CXX) -c -o $@ $^ -Iinclude/files $(CXXFLAGS)

$(pointers_obj): $(pointers_src)
	$(CXX) -c -o $@ $^ -Iinclude/pointers $(CXXFLAGS)

$(libdir):
	$(mkdircmd) $@

$(bindir):
	$(mkdircmd) $@

.PHONY: clean

clean: $(libdir) $(bindir)
	$(rmcmd) $^

