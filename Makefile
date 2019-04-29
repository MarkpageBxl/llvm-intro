.SUFFIXES:
.PHONY: clean all doc

CC := clang

CFLAGS += -std=c11
CFLAGS += -Wall -Wextra -Wpedantic
BITS ?= 32

ifeq ($(BITS),32)
CFLAGS += -m32
else
CFLAGS += -m64
endif

SOURCES := $(shell ls -1 *.c)

LL := $(SOURCES:.c=.o0.ll)
LLOPT1 := $(SOURCES:.c=.o1.ll)
LLOPT2 := $(SOURCES:.c=.o2.ll)
LLOPT3 := $(SOURCES:.c=.o3.ll)
ALL_LL := $(LL) $(LLOPT1) $(LLOPT2) $(LLOPT3)

ASM := $(SOURCES:.c=.o0.s)
ASMOPT1 := $(SOURCES:.c=.o1.s)
ASMOPT2 := $(SOURCES:.c=.o2.s)
ASMOPT3 := $(SOURCES:.c=.o3.s)
ALL_ASM := $(ASM) $(ASMOPT1) $(ASMOPT2) $(ASMOPT3)


all: $(ALL_LL) $(ALL_ASM)

%.o0.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -O0 -o $@ $<

%.o1.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -O1 -o $@ $<

%.o2.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -O2 -o $@ $<

%.o3.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -O3 -o $@ $<

%.s: %.ll
	llc --x86-asm-syntax=intel -o $@ $<

%.ll: %.c
	$(CC) $(CFLAGS) -S -emit-llvm -o $@ $<

clean:
	rm -rf *.ll *.s *.html

doc: README.html

%.html: %.adoc
	asciidoctor $<
