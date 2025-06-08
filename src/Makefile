ASM_OPTIONS:=-felf32
ifdef DEBUG
	ASM_OPTIONS+=-g
endif

.PHONY: build
build libnastx.a: nastx.o
	ar crs libnastx.a nastx.o

nastx.o: nastx.asm
	nasm $(ASM_OPTIONS) nastx.asm -o nastx.o

.PHONY: test
test: nastx.o
	./runtest.sh

.PHONY: install
install: libnastx.a
ifndef PREFIX
	$(error Set the PREFIX variable e.g. PREFIX=/usr )
endif
	install -b -D -t "$(PREFIX)/lib" libnastx.a
	install -b -D -t "$(PREFIX)/include" nastx.inc nastx.h

.PHONY: clean
clean:
	rm libnastx.a
	rm nastx.o


