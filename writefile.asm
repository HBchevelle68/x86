global _start
section .data

  fmsg: db "Enter Filename: "
  .fmsg: equ $ - fmsg

  buff: times 200 db 0  ;array for user string
  .blen: equ $ - buff

  fname: times 200 db 0 ;array for filename
  .flen: equ $ - buff

section .bss
  fd: resd 1            ;file descriptor
  bret: resd 1          ;read buffer return value
  fret: resd 1          ;read filename return value
  tmp: resd 1           ;temp 4 byte variable

section .text
_start








filein:
  mov eax, 0x3	        ;syscall 3 - read()
  mov ebx, 0x0	        ;file desc 0 - stdin
  mov ecx, buff         ;dst buffer
  mov edx, buff.blen    ;length of buffer
  int 80h			          ;syscall interupt
  mov [tmp], eax        ;save return value to len
  cmp eax, edx	        ;read max bytes or more?
  jb  pback		          ;jmp is bytes read < max
  mov bl, [ecx+eax-1]   ;grab last byte @ last index before '\0'
  cmp bl, 10            ;does it = '\n' ?
  je  loop
  inc DWORD [tmp]       ;len++

clean:                ;loop to clear excess input
	mov eax, 0x3        ;syscall 3 - read()
	mov ebx, 0x0        ;file desc 0 - stdin
	mov ecx, tmp        ;temp buffer
	mov edx, 0x1		    ;read only 1 byte
	int 80h             ;syscall
	test eax, eax       ;EOF?
	jz  pback           ;Yes, jump to pback
	mov al, [tmp]       ;put character into lower 8 bits of EAX
	cmp al, 10          ;is it = to lf ?
	jne clean           ;no, jump to begining of loop

userin:
