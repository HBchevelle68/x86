all: Hello

Hello: hello.asm 
	nasm -f elf hello.asm 
	ld -melf_i386 hello.o -o helloWorld

clean: 
	rm *.o helloWorld