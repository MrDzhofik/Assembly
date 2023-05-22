%include "../../lib64.asm"

section .data
     text dq '~d7 abcd uuuiuu ~t4', 0
     text1 dq 'b', 0
     len dd 17
section .bss
  cur_len resb 1
  CurrentSym resb 1
  original_text resb 100
  
global _Z5modifPci
extern _Z6printPc
     section .text
_Z5modifPci:
     
     push    rbp
     mov     rbp,rsp
     ; mov     [len], rsi ; запись длины строки
     mov     rcx, [len]
     mov rsi, rdi
;     lea rsi, [text]
     lea rdi, [text1]
     mov [original_text], rdi
loop1:
     cmp byte[rsi], "~"
     je zap
     movsb
     cmp rcx, 0
     jl exit
     loop loop1
     mov [original_text], rdi
     ; lea rdi, [original_text]
     jmp exit

zap:
    inc rsi
    mov al, byte[rsi]
    mov [CurrentSym], al
    inc rsi
    mov al, byte[rsi]
    mov [cur_len], al
    inc rsi
;     push rsi
;     push rdi
;     mov rsi, cur_len
;     call StrToInt64
;     pop rdi
;     pop rsi
    push rcx
    mov rcx, rax
    sub rcx, 48
    push rsi
    mov al, [CurrentSym]
    rep stosb
    pop rsi
    pop rcx
    sub rcx, 3
    jmp loop1

exit:
     ; mov     [rdx], esi
     mov     rsp,rbp
     pop     rbp
     ret
