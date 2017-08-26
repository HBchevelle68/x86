global _start

section .data
  buff:  times 50 db 0
    .len: equ $ - buff
  f1: db "Test1.txt", 0
    .len: equ $ - f1
  f2: db "Test2.txt", 0
    .len: equ $ - f2
  err1: db "Error opening file 1", 0x0a
    .len: equ $ - err1
  err2: db "Error opening file 2", 0x0a
    .len: equ $ - err2


section .rodata
  ;modes
  O_RDONLY: equ 0        ;read-only
  O_WRONLY: equ 1        ;wirte-only
  O_RDWR:   equ 2        ;read and write

  ;flags
  O_CREAT:  equ 100o     ;create file if file doesnt exists
  O_TRUNC:  equ 1000o    ;truncate file
  O_APPEND: equ 2000o    ;append to file

  SEEK_SET:	equ 0	       ;set file offset to offset
  SEEK_CUR:	equ 1	       ;set file offset to current plus offset
  SEEK_END: equ	2	       ;set file offset to EOF plus offset

section .bss
  fd1:  resd 1
  fd2:  resd 1
  tmp:  resd 1
  sz:   resd 1

section .text
_start:
  nop
  nop
  mov eax, 0x5
  mov ebx, f1
  mov ecx, O_RDONLY  ;flags/mode
  int 80h
  cmp eax, 0
  jb error1
  mov [fd1], eax

  mov eax, 0x5
  mov ebx, f2
  mov ecx, O_WRONLY | O_CREAT | O_TRUNC  ;flags/mode
  mov edx, 0666o            ;file permissions
  int 80h
  cmp eax, 0                ;check ret for errors
  jb error2
  mov [fd2], eax

while:
  mov eax, 0x3
  mov ebx, [fd1]
  mov ecx, tmp
  mov edx, 0x1              ;read 1 byte
  int 80h
  test eax, eax             ;EOF?
  jz break                  ;if EOF jump out
  inc DWORD [sz]            ;otherwise increment and loop
  jmp while                 ;begin loop

break:
  mov eax, 0x13             ;lseek sys call
  mov ebx, [fd1]            ;file desc 1
  mov ecx, 0x0              ;file offset to go to
  mov edx, SEEK_SET         ;set file pointer back to position pointed to by ecx
  int 80h
  mov eax, 0x3              ;read syscall
  mov ebx, [fd1]            ;file desc 1
  mov ecx, buff             ;buffer to read into
  mov edx, [sz]             ;read [sz] amount of bytes into buffer
  int 80h
  mov edx, buff             ;buffer
  mov ecx, [sz]             ;size of buffer in bytes
  mov BYTE [edx + ecx], 0x0 ;null terminate end of buffer
  mov eax, 0x4              ;write syscall
  mov ebx, [fd2]            ;file desc 2
  mov ecx, buff             ;buffer containing string
  mov edx, [sz]             ;num bytes to write
  int 80h

clean:                      ;close up files and exit(0)
  mov eax, 0x6
  mov ebx, [fd1]
  int 80h

  mov eax, 0x6
  mov ebx, [fd2]
  int 80h

  mov eax, 0x1
  int 80h


error1:                      ;print errors
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, err1
  mov edx, err1.len
  int 80h
  jmp clean

error2:
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, err2
  mov edx, err2.len
  int 80h
  jmp clean
