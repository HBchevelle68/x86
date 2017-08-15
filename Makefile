all: hello echo

hello: hello.asm 
	nasm -f elf hello.asm 
	ld -melf_i386 hello.o -o helloWorld

echo: echo.asm
	nasm -f elf echo.asm
	ld -melf_i386 echo.o -o echo

clean: 
	rm *.o helloWorld echo