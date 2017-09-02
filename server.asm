global _start

section .data
  listening: db "Listening...",10 ,0
  .len: equ $ - listening
  connection: db "Connection!",10 ,0
  .len: equ $ - connection

section .bss
  fd:          resd 1
  cli_fd:      resd 1
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
  ;Addresses
  INADDR_ANY:      equ 0

section .text
_start:


socket:;sockfd = socket(AF_INET, SOCK_STREAM, 0)
  mov eax, 0x66
  mov ebx, SYS_SOCKET
  push DWORD IPPROTO_IP
  push DWORD SOCK_STREAM
  push DWORD AF_INET
  mov ecx, esp    ;ptr start of args array
  int 80h
  add esp, 12     ;clean stack
  mov [fd], eax   ;save file descriptor

sockopts:;setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))
  mov eax, 0x66
  mov ebx, SYS_SETSOCKOPT
  push DWORD 4    ;sizeof(on)
  push DWORD esp  ;&on
  push DWORD SO_REUSEADDR
  push DWORD SOL_SOCKET
  push DWORD [fd]
  mov ecx, esp  ;ptr start of args array
  int 80h
  add esp, 20   ;clean stack

bind:;bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr))
  mov eax, 0x66
  mov ebx, SYS_BIND
  push DWORD INADDR_ANY
  push WORD 0xE110 ;(port 4321 = 0x10E1, in reverse byte order = 0xE110)
  push WORD AF_INET
  mov ecx, esp ;save a ptr to sockaddr_in structure
  push DWORD 16 ;sizeof sockaddr_in
  push ecx ;ptr to sockaddr_in structure
  push DWORD [fd]
  mov ecx, esp ;ptr to args as per syscall specs
  int 80h
  add esp, 16 ;clean stack

listen:;listen(sockfd, 5)
  mov eax, 0x66
  mov ebx, SYS_LISTEN
  push DWORD 5 ;set queue sixe to 5
  push DWORD [fd] ;file descriptor
  mov ecx, esp ;ptr to args
  int 80h
  add esp, 8 ;clean stack
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, listening
  mov edx, listening.len
  int 80h

accept:;accept(sockfd, (struct sockaddr*) NULL, NULL)
  mov eax, 0x66
  mov ebx, SYS_ACCEPT
  push DWORD 0 ;NULL
  push DWORD 0 ;NULL
  push DWORD [fd] ;file descriptor
  mov ecx, esp
  int 80h
  add esp, 12 ;clean stack
  mov [cli_fd], eax ;save file descriptor
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, connection
  mov edx, connection.len
  int 80h

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
