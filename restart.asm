global _start

section .data

section .rodata

section .bss

section .text
_start:
 mov eax, 0x0
 int 80h

 mov eax, 0x1
 mov ebx, 0x0
 int 80h
