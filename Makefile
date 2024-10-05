


all: hello test


hello.o: hello.asm
	nasm -f elf64 -o hello.o hello.asm

hello: hello.o
	ld -o hello hello.o

test.c: hello gen_shellcode.sh
	bash gen_shellcode.sh hello > test.c

test: test.c
	gcc -o test test.c -z execstack

clean:
	rm -f hello.o hello test test.c
