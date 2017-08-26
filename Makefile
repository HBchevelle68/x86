OBJS = hello echoname writefile fcopy


all: $(OBJS)

hello: hello.asm
	nasm -f elf hello.asm
	ld -melf_i386 hello.o -o helloWorld

echoname: echoname.asm
	nasm -f elf echoname.asm
	ld -melf_i386 echoname.o -o echoname

writefile: writefile.asm
	nasm -f elf writefile.asm
	ld -melf_i386 writefile.o -o writefile

fcopy: fcopy.asm
	nasm -f elf fcopy.asm
	ld -melf_i386 fcopy.o -o fcopy

mem: mem.asm
	nasm -f elf mem.asm
	ld -melf_i386 -lc -I /lib/ld-linux.so.2 mem.o -o mem

clean:
	rm *.o helloWorld echoname writefile fcopy mem
