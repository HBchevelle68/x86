global main
extern printf

section .data
  msg: db "Address = 0x%08X", 10, 0

section .bss
  location: resd 1

section .text
main:
  mov dword eax, location
  push dword eax
  push msg
  call printf
  add esp, 8

  mov eax, 0x1
  int 80h

_printaddr:
  push ebp
