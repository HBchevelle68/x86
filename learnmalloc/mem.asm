global main
; glibc stuff
extern malloc, free

section .data
  err: db "malloc failed!", 10, 0
    .len: equ $ - err

section .bss
  mptr resd 1   ;pointer to begining of malloc'd memory

section .text
main:

  push 20       ;allocate 20 bytes
  call malloc   ;call malloc
  add esp, 4    ;clean pushed imm

  test eax, eax ;check for malloc error
  jz merror

  mov [mptr], eax ;store address

  mov byte [eax], 0
  mov byte [eax + 1], 1

  push dword [mptr]     ;push address
  call free             ;call free
  add esp, 4            ;clean push

exit:
  mov eax, 0x1
  int 80h

merror:
  mov eax, 0x4
  mov ebx, 0x1
  mov ecx, err
  mov edx, err.len
  int 80h
  jmp exit
