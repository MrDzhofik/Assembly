section .data
    multi dd 1
    matrix dd 2, 1, 2, 3, 4, 5
           dd 0, -1, -2, -3, -4, -5
           dd 1, 1, 1, 1, 1, 1
           dd -2, -3, -8, -7, -9, -11
           dd 2, -8, 7, 16, 5, 4
           dd 9, 11, 7, 8, 12, -3
section .bss
    OutBuf resw 1
    result resd 1

section .text
    global _start
    _start:
        mov eax, [multi]

        mov rcx, 6
        mov r9, 5
    mult:
        mov ebx, [matrix + 4 * r9]
        cmp ebx, 0
        JNG skip
        mul ebx
        add r9, 5
        loop mult
        jmp check
    skip:
        dec rcx
        add r9, 5
        jmp mult
    check:
        mov ebx, [matrix]
        cmp ebx, 0
        jne output
        jmp exit
    output:
        mov ebx, [matrix]
        cdq
        div ebx
        mov [result], eax
        mov [matrix], eax

        mov ecx, 36
        mov rbx, 0
    cycl:
        push rcx
        mov eax, [matrix + 4*rbx]
        inc rbx
        mov rsi, OutBuf
        call IntToStr64
        mov rax, 1
        mov rdi, 1
        mov rsi, OutBuf
        mov rdx, 4
        syscall
        pop rcx
        loop cycl
    exit:
        xor rdi, rdi
        mov rax, 60
        syscall
    
%include "../lib64.asm"