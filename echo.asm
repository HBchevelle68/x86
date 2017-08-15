global _start

section .data
	msg: db "Enter your name: "	;Print to user
	.len: equ $ - msg	

	buffer: times 64 db 0  ;Reserve 64 bytes, values set to 0 
	lf:  db 10			   ;'\n'

section .bss
	len resb 1          ;integer
    dummy resb 1        ;integer


section .text
_start:

	                    ;Print prompt
 	mov eax, 0x4	    ;syscall 3 - read()
	mov ebx, 0x1	    ;file desc 1 - stdout
	mov ecx, msg        ;print message
	mov edx, msg.len    ;length of message
	int 80h			    ;syscall interupt
	
	                    ;Read input
	mov eax, 0x3	    ;syscall 3 - read()
	mov ebx, 0x0	    ;file desc 0 - stdin
	mov ecx, buffer     ;dst buffer
	mov edx, 64         ;length of buffer
	int 80h			    ;syscall interupt


	mov [len], eax      ;save return value to len
	cmp eax, edx	    ;read max bytes?
	jb  pback		    ;jump if not all bytes read
    mov bl, [ecx+eax-1] ;grab last byte before '\0'
    cmp bl, 10          ;does it = lf ?
    je  loop
	inc DWORD [len]     ;len++


loop:                   ;loop to clear excess input?
	mov eax, 0x3        ;syscall 3 - read()
	mov ebx, 0x0        ;file desc 0 - stdin
	mov ecx, dummy      ;temp buffer
	mov edx, 0x1		;read only 1 byte
	int 80h             ;syscall
	test eax, eax       ;EOF?
	jz  pback           ;Yes, jump to pback
	mov al, [dummy]     ;put character into lower 8 bits of EAX
	cmp al, 10          ;is it = to lf ?
	jne loop            ;no, jump to loop


pback:
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, buffer
	mov edx, [len]
	int 80h

	                  ;return 0
	mov eax, 1        ;syscall 1 - exit()
    mov ebx, 0        ;return val
    int 80h           ;syscall interupt 