OBJS = hello echoname writefile restart


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

restart: restart.asm
	nasm -f elf restart.asm
	ld -melf_i386 restart.o -o restart

clean:
	rm *.o helloWorld echoname writefile restart
