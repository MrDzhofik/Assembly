section .data
     text db "Original text: ", 0
     text1 dq 'b', 0
section .bss
  cur_len resb 1
  len resb 1
  CurrentSym resb 1
  original_text resb 100
  
global modif
extern print
     section .text
modif:
     push    rbp
     mov     rbp, rsp
     mov     [len], rsi
     mov     rcx, rsi
     mov [cur_len], rsi
     mov rsi, rdi
     lea rdi, [text1]
loop1:
     cmp byte[rsi], "~"
     je zap
     movsb
     cmp rcx, 0
     jle exit
     loop loop1
     jmp exit

zap:
    inc rsi
    xor rax, rax
    mov al, byte[rsi]
    mov [CurrentSym], al
    inc rsi
    mov al, byte[rsi]
    mov [cur_len], al
    inc rsi
    push rcx
    mov rcx, rax
    sub rcx, 48
    add [len], rcx
    push rsi
    mov al, [CurrentSym]
    rep stosb
    pop rsi
    pop rcx
    sub rcx, 3
    jmp loop1

exit:
     lea rdi, [text1]
     call print
     pop rax
     pop rcx
     mov     rsp,rbp
     pop     rbp
     ret
