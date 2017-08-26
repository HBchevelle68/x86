global _start
; glibc stuff
extern _malloc, _free

section .data
  err: db "malloc failed!", 10, 0
    .len: equ $ - err

section .bss
  mptr resd 1   ;pointer to begining of malloc'd memory

section .text
_start:

  push 20       ;allocate 20 bytes
  call _malloc  ;call malloc
  add esp, 4    ;clean pushed imm

  test eax, eax ;check for malloc error
  jz merror

  mov [mptr], eax ;store address

  mov byte [eax], 0
  mov byte [eax + 1], 1

  push mptr     ;push address
  call _free    ;call free
  add esp, 4    ;clean push

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
