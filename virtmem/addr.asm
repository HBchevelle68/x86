global main
extern printf

section .data
  msg: db "Address = 0x%08X", 10, 0

section .bss
  location: resd 1

section .text
main:
  push DWORD location

  call _printaddr
  add esp, 4

  mov eax, 0x1
  int 80h

_printaddr:
  push ebp         ;save the base pointer
  mov ebp, esp     ;move the stack pointer into base pointer
  push edi         ;save registers that function will use

  ;Begin actual function
  push DWORD [ebp+8] ;grab param 1 and move into local 1 (variable)
  push msg
  call printf
  add esp, 8

  mov esp, ebp
  pop ebp
  ret
