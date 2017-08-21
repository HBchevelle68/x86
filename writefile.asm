global _start
section .data
  fmsg:  db "Enter Filename: ", 0
  .len:  equ $ - fmsg
  umsg:  db "Enter message: ", 0
  .len:  equ $ - umsg
  buff:  times 50 db 0  ;array for user string
  .blen: equ $ - buff
  fname: times 50 db 0 ;array for filename
  .flen: equ $ - fname

section .rodata
  ;modes
  O_RDONLY: equ 0        ;read-only
  O_WRONLY: equ 1        ;wirte-only
  O_RDWR:   equ 2        ;read and write

  ;flags
  O_CREAT:  equ 100o     ;create file if file doesnt exists
  O_TRUNC:  equ 1000o    ;truncate file
  O_APPEND: equ 2000o    ;append to file


section .bss
  fd:   resd 1          ;file descriptor
  bret: resd 1          ;read buffer return value
  fret: resd 1          ;read filename return value
  tmp:  resd 1          ;temp 4 byte variable

section .text
_start:

fprompt:               ;Print prompt
  mov eax, 0x4	       ;syscall 4 - write()
  mov ebx, 0x1	       ;file desc 1 - stdout
  mov ecx, fmsg        ;print message
  mov edx, fmsg.len    ;length of message
  int 80h			         ;;syscall interupt

filein:
  mov eax, 0x3	        ;syscall 3 - read()
  mov ebx, 0x0	        ;file desc 0 - stdin
  mov ecx, fname        ;dst buffer
  mov edx, fname.flen   ;length of buffer
  int 80h			          ;syscall interupt
  mov [fret], eax       ;save return value to file return variable
  cmp eax, edx	        ;read max bytes or more?
  jb  fileopen	        ;jmp is bytes read < max
  mov bl, [ecx+eax-1]   ;grab last byte @ last index before '\0'
  cmp bl, 10            ;does it = '\n' ?
  je  clean1
  inc DWORD [fret]      ;len++

clean1:               ;loop to clear excess input, if any
  mov eax, 0x3        ;syscall 3 - read()
  mov ebx, 0x0        ;file desc 0 - stdin
  mov ecx, tmp        ;temp buffer
  mov edx, 0x1		    ;read only 1 byte
  int 80h             ;;syscall interupt
  test eax, eax       ;EOF?
  jz  fileopen        ;Yes, jump to pback
  mov al, [tmp]       ;put character into lower 8 bits of EAX
  cmp al, 10          ;is it = to lf ?
  jne clean1          ;no, jump to begining of loop

fileopen:
  mov eax, [fret]                     ;load length of filename
  mov ebx, fname                      ;load filename address
  mov BYTE [ebx+eax-1], 0             ;null terminate it
  mov eax, 0x05                       ;syscall 5 - open()
  mov ebx, fname                      ;filename
  mov ecx, O_CREAT | O_TRUNC | O_RDWR ;flags/mode
  mov edx, 0666o                      ;read/write only
  int 80h                             ;syscall interupt
  mov [fd], eax                       ;save file descripor

prompt2:
  mov eax, 0x4	       ;syscall 4 - write()
  mov ebx, 0x1	       ;file desc 1 - stdout
  mov ecx, umsg        ;print message
  mov edx, umsg.len    ;length of message
  int 80h

userin:
  mov eax, 0x3	        ;syscall 3 - read()
  mov ebx, 0x0	        ;file desc 0 - stdin
  mov ecx, buff         ;dst buffer
  mov edx, buff.blen    ;length of buffer
  int 80h			          ;syscall interupt
  mov [bret], eax       ;save return value to buff return variable
  cmp eax, edx	        ;read max bytes or more?
  jb  writetofile	      ;jmp is bytes read < max
  mov bl, [ecx+eax-1]   ;grab last byte @ last index before '\0'
  cmp bl, 10            ;does it = '\n' ?
  je  clean2
  inc DWORD [bret]      ;len++

clean2:               ;loop to clear excess input, if any
  mov eax, 0x3        ;syscall 3 - read()
  mov ebx, 0x0        ;file desc 0 - stdin
  mov ecx, tmp        ;temp buffer
  mov edx, 0x1		    ;read only 1 byte
  int 80h             ;syscall
  test eax, eax       ;EOF?
  jz  writetofile     ;Yes, jump to pback
  mov al, [tmp]       ;put character into lower 8 bits of EAX
  cmp al, 10          ;is it = to lf ?
  jne clean2          ;no, jump to begining of loop


writetofile:
  mov eax, 0x4	       ;syscall 4 - write()
  mov ebx, [fd]	       ;file desc 1 - stdout
  mov ecx, buff        ;print message
  mov edx, [bret]      ;length of message
  int 80h

closefile:
  mov eax, 0x6	    ;syscall 6 - close()
  mov ebx, [fd]	    ;file desc
  int 80h

exit:               ;return 0
  mov eax, 1        ;syscall 1 - exit()
  mov ebx, 0        ;return val
  int 80h           ;syscall interupt
