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
  mov edx, 0666o
  int 80h
  cmp eax, 0
  jb error2
  mov [fd2], eax

while:
  mov eax, 0x3
  mov ebx, [fd1]
  mov ecx, tmp
  mov edx, 0x1   ; read 1 byte
  int 80h
  test eax, eax  ; EOF?
  jz break       ; if EOF jump out
  inc DWORD [sz] ; otherwise increment and loop
  jmp while

break:

  mov eax, 0x3
  mov ebx, [fd1]
  mov ecx, buff
  mov edx, buff.len
  int 80h
  mov edx, buff
  mov ecx, [sz]
  mov BYTE [edx + ecx], 0x0
  mov eax, 0x4
  mov ebx, [fd2]
  mov ecx, buff
  mov edx, [sz]
  int 80h

clean:
  mov eax, 0x6
  mov ebx, [fd1]
  int 80h

  mov eax, 0x6
  mov ebx, [fd2]
  int 80h

  mov eax, 0x1
  int 80h


error1:
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, err1
  mov edx, err1.len
  int 80h
  ;jmp nodata

error2:
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, err2
  mov edx, err2.len
  int 80h
  ;jmp nodata
