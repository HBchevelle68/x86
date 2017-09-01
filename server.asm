global _start

section .data

section .bss
  fd:          resd 1
  portno:      resd 1

section .rodata
  ;Socket calls
  SYS_SOCKET:      equ 1
  SYS_BIND:        equ 2
  SYS_CONNECT:     equ 3
  SYS_LISTEN:      equ 4
  SYS_ACCEPT:      equ 5
  SYS_SEND:        equ 9
  SYS_RECV:        equ 10
  SYS_SETSOCKOPT:  equ 14
  ;Domains
  AF_INET:         equ 2
  ;Types
  SOCK_STREAM:     equ 1
  ;Protocols
  IPPROTO_IP:      equ 0
  ;Socket options
  SOL_SOCKET:      equ 1
  SO_REUSEADDR:    equ 2


section .text
_start:


socket:
  mov eax, 0x66
  mov ebx, [SYS_SOCKET]
  push DWORD [IPPROTO_IP]
  push DWORD [SOCK_STREAM]
  push DWORD [AF_INET]
  mov ecx, esp    ;ptr start of args array
  int 80h
  add esp, 12     ;clean stack
  mov [fd], eax   ;save file descriptor

sockopts:
  mov eax, 0x66
  mov ebx, [SYS_SETSOCKOPT]
  push dword 4    ;sizeof(int)
  push esp  ;&int
  push DWORD [SO_REUSEADDR]
  push DWORD [SOL_SOCKET]
  push DWORD [fd]
  mov ecx, esp  ;ptr start of args array
  int 80h
  add esp, 16   ;clean stack


closesock:
  mov eax, 0x6
  mov ebx, [fd]
  int 80h
  jmp exit0 ; Temp

exit1:
  mov eax, 0x1
  mov ebx, 0x1
  int 80h

exit0:
  mov eax, 0x1
  xor ebx, ebx
  int 80h
