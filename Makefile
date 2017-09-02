OBJS = hello echoname writefile fcopy mem


all: $(OBJS)

hello: helloworld/hello.asm
	nasm -f elf helloworld/hello.asm
	ld -melf_i386 helloworld/hello.o -o helloworld/hello

echoname: echoname/echoname.asm
	nasm -f elf echoname/echoname.asm
	ld -melf_i386 echoname/echoname.o -o echoname/echoname

writefile: writefile/writefile.asm
	nasm -f elf writefile/writefile.asm
	ld -melf_i386 writefile/writefile.o -o writefile/writefile

fcopy: filecopy/fcopy.asm
	nasm -f elf filecopy/fcopy.asm
	ld -melf_i386 filecopy/fcopy.o -o filecopy/fcopy

mem: learnmalloc/mem.asm
	nasm -f elf learnmalloc/mem.asm
	gcc -m32 learnmalloc/mem.o -o learnmalloc/mem

addr: virtmem/addr.asm
	nasm -f elf virtmem/addr.asm
	gcc -m32 virtmem/addr.o -o virtmem/addr

server: server.asm
	nasm -f  elf -g server.asm
	ld -melf_i386 -g server.o -o server

clean:
	rm *.o server
