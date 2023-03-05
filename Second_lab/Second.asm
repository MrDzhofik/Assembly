%include "../lib64.asm"

section .data
; сегмент инициализированных переменных
Msg db "Enter a, c(not null), d, l", 10 ; выводимое сообщение
len db $-Msg
; сегмент неинициализированных переменных
section .bss
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf

X resw 1
InBuf resb 10
lenIn equ $-InBuf
a resw 1
c resw 1
k resw 1
d resw 1
l resw 1
result resw 1
; lenIn equ $-InBuf
section .text
global _start
_start:

    ;write
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, Msg ; адрес выводимой строки
    mov rdx, len ; длина строки
    syscall

    ; read a
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [a], rax

    ; read c
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [c], rax

    ; read d
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [d], rax

    ; read l
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 4
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [l], rax

    ; solve
    mov EAX, [l]
    sub EAX, [a]
    mul EAX
    ; div WORD[c]
    add EAX, [d]
    sub EAX, [l]
    mov EBX, EAX
    mov EAX, [c]
    ; div WORD[d]
    add EAX, EBX
    mov [result], EAX

    ; write
    mov rsi, OutBuf ; адрес выводимой строки
    mov ax, [result]
    cwde
    call IntToStr64
    mov ebp, eax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    ; mov rcx, rsi ; адрес выводимой строки
    mov rdx, rbp ; длина выводимой строки
    syscall ; вызов системной функции
    ; mov ax, [A]
    ; cwde
    ; call IntToStr64

    ; 1) ; write
    ; mov rax, 1 ; системная функция 1 (write)
    ; mov rdi, 1 ; дескриптор файла stdout=1
    ; mov rsi, ExitMsg ; адрес выводимой строки
    ; mov rdx, lenExit ; длина строки
    ; ; вызов системной функции
    ; syscall

    ; exit
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall