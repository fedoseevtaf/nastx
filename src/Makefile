ASM_OPTIONS:=-felf32
ifdef DEBUG
	ASM_OPTIONS+=-g
endif

nastx.o: nastx.asm
	nasm $(ASM_OPTIONS) nastx.asm -o nastx.o 

.PHONY: test
test:
	./runtest.sh

clean:
	rm -rf *.o


