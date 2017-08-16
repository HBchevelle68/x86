all: hello echoname

hello: hello.asm
	nasm -f elf hello.asm
	ld -melf_i386 hello.o -o helloWorld

echoname: echoname.asm
	nasm -f elf echoname.asm
	ld -melf_i386 echoname.o -o echoname

clean:
	rm *.o helloWorld echoname
