section .data
    text dq "~d7 abcd ~k4 siu" 
    len dq 16
    text1 dq 'b', 0
section .bss
  cur_len resb 1
  CurrentSym resb 1
  original_text resd 100
  
global _start
extern _Z5printPc
     section .text
_start:

     push    rbp
     mov     rbp, rsp
     mov     rcx, [len]
     lea rsi, [text]
     lea rdi, [text1]
     mov [original_text], rdi
loop1:
     cmp byte[rsi], "~"
     je zap
     movsb
     cmp rcx, 0
     jl exit
     loop loop1
    ;  mov [original_text], rdi
    ;  lea rdi, [original_text]
     jmp exit

zap:
    inc rsi
    mov al, byte[rsi]
    mov [CurrentSym], al
    inc rsi
    mov al, byte[rsi]
    mov [cur_len], al
    inc rsi
    push rcx
    mov ecx, eax
    sub ecx, 48
    add [len], ecx
    push rsi
    mov al, [CurrentSym]
    rep stosb
    pop rsi
    pop rcx
    sub rcx, 3
    jmp loop1

exit:
    mov rsi, rdi ; адрес выводимой строки
    sub rsi, [len]
    ; mov rax, [result]
    ; cwde
    ; call IntToStr64
    ; mov rbp, rax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rdx, [len] ; длина выводимой строки
    syscall ; вызов системной функции

    mov rax, 60
    xor rbp, rbp
    syscall
    ;  pop rax
    ;  pop rcx
    ;  mov     rsp,rbp
    ;  pop     rbp
    ;  ret
