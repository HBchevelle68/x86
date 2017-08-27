global main
extern printf

section .data
  msg: db "Address = 0x%08X", 10, 0

section .bss
  location: resd 1

section .text
main:
  mov DWORD eax, location
  push DWORD eax

  call _printaddr
  add esp, 4

  mov eax, 0x1
  int 80h

_printaddr:
  push ebp         ;save the base pointer
  mov ebp, esp     ;move the stack pointer into base pointer
  ;sub esp, DWORD*1 ;allocate room on the stack for 1 4 byte local variables
  push edi         ;save registers that function will use

  ;Begin actual function
  mov edi, [ebp+4] ;grab param 1 and move into local 1 (variable)
  push DWORD edi
  push msg
  call printf
  add esp, 8

  pop edi
  mov esp, ebp
  pop ebp
  ret
