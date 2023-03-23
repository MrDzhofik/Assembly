%include "../lib64.asm"

section .data
; сегмент инициализированных переменных
ZeroMsg db "C is equal zero",10
lenZero equ $-ZeroMsg

Msg dq "Enter a, c(not null), d, l", 10 ; выводимое сообщение
len db $-Msg

; сегмент неинициализированных переменных
section .bss
OutBuf resb 10 ; буфер для вводимой строки
lenOut equ $-OutBuf
CBuf resb 10 ; буфер для вводимой строки
lenC equ $-CBuf
X resw 1
InBuf resb 10
lenIn equ $-InBuf
a resd 1
c resd 1
d resd 1
l resd 1
result resw 1
; lenIn equ $-InBuf
section .text
global _start
_start:

    ;write
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, Msg ; адрес выводимой строки
    mov rdx, [len] ; длина строки
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


    mov rsi, CBuf ; адрес выводимой строки
    mov rax, [c]
    cwde
    call IntToStr64
    mov rbp, rax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rdx, rbp ; длина выводимой строки
    syscall ; вызов системной функции

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

    mov eax, [c]
    cmp eax, 0
    je  zero 

    ; solve
    mov EAX, [l]
    sub EAX, [a]
    imul EAX
    mov ebx, [c]
    idiv ebx
    add EAX, [d]
    sub EAX, [l]
    mov EBX, EAX
    mov EAX, [c]
    mov ECX, 2
    idiv ECX
    add EAX, EBX
    mov [result], EAX

   

    ; write
    mov rsi, OutBuf ; адрес выводимой строки
    mov rax, [result]
    cwde
    call IntToStr64
    mov rbp, rax
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rdx, rbp ; длина выводимой строки
    syscall ; вызов системной функции


    zero:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ZeroMsg ; адрес выводимой строки
    mov rdx, lenZero; длина строки
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall