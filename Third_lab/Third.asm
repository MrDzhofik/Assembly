%include "../lib64.asm"

section .data
; сегмент инициализированных переменных
DopMsg dq "Enter k:", 10
lenDop equ $-DopMsg

ZeroMsg dq "Division by zero", 10
lenZero equ $-ZeroMsg

Msg dq "Enter a, m", 10 ; выводимое сообщение
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
m resd 1
k resd 1
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
    mov rax, 0 ; системная функция 0 (read)
    mov rdi, 0 ; дескриптор файла stdin=1
    mov rsi, InBuf ; адрес вводимой строки
    mov rdx, 6 ; длина строки
    syscall ; вызов системной функции
    mov rsi, InBuf ; адрес введеной строки
    call StrToInt64 ; преобразование введеной строки в число
    mov [a], rax ; запись введеного числа в переменную а

    ; read m
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, 6
    syscall
    mov rsi, InBuf
    call StrToInt64
    mov [m], rax

    ; solve
    mov EAX, [m]
    mov EBX, [a]
    cmp EAX, EBX
    JLE else
    sub EAX, 5 
    mov [result], EAX
    JMP exit
    

   

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



    else:
        ;write
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, DopMsg ; адрес выводимой строки
        mov rdx, lenDop ; длина строки
        syscall

        ;read k
        mov rax, 0
        mov rdi, 0
        mov rsi, InBuf
        mov rdx, 4
        syscall
        mov rsi, InBuf
        call StrToInt64
        mov [k], rax


        ; check k
        cmp rax, 0
        je zero 

        ;solve
        mov EAX, [m]
        mov EBX, [a]
        imul EBX
        mov ECX, [k]
        idiv ECX
        mov [result], EAX

        jmp exit

    exit: 
        ; write
        mov rsi, OutBuf ; адрес выводимой строки
        mov rax, [result] ; загрузка числа в регистр
        cwde ; развертывание числа из АХ в ЕАХ
        call IntToStr64 ; преобразование числа в строку
        mov rbp, rax ; длина строки
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rdx, rbp ; длина выводимой строки
        syscall ; вызов системной функции
        mov rax, 60 ; системная функция 60 (exit)
        xor rdi, rdi ; return code 0
        syscall 

    zero:
        mov rax, 1; системная функция 1 (write)
        mov rdi, 1; дескриптор файла stdout=1
        mov rsi, ZeroMsg ; адрес выводимой строки
        mov rdx, lenZero ; длина строки
        syscall
        mov rax, 60 ; системная функция 60 (exit)
        xor rdi, rdi ; return code 0
        syscall