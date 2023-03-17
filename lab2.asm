   section .data

EntrMsgb db "Enter b:",10
lenEntrb equ $-EntrMsgb

EntrMsgf db "Enter f:",10
lenEntrf equ $-EntrMsgf

EntrMsgk db "Enter k:",10
lenEntrk equ $-EntrMsgk

EntrMsgn db "Enter n:",10
lenEntrn equ $-EntrMsgn

EntrMsgr db "Enter r:",10
lenEntrr equ $-EntrMsgr

EntrMsgm db "Enter m:",10
lenEntrm equ $-EntrMsgm

ExitMsg db "Answer:",10
lenExit equ $-ExitMsg
ZeroMsg db "k is equal zero",10
lenZero equ $-ZeroMsg


    section .bss

InBuf   resb    10 
lenIn   equ     $-InBuf
OutBuf  resb    10
lenOut  equ     $-OutBuf 

X       resw    1

B       resw    1
F       resw    1
K       resw    1
N       resw    1
R       resw    1
M       resw    1


    section .text 
    global _start
_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, EntrMsgb 
    mov rdx, lenEntrb 
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64
    cmp     EBX, 0   
    jne     StrToInt64.Error 
    mov     [B],ax  

    mov rax, 1
    mov rdi, 1
    mov rsi, EntrMsgf 
    mov rdx, lenEntrf 
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64
    cmp     EBX, 0   
    jne     StrToInt64.Error 
    mov     [F],ax  

    mov rax, 1
    mov rdi, 1
    mov rsi, EntrMsgk 
    mov rdx, lenEntrk 
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64
    cmp     EBX, 0   
    jne     StrToInt64.Error 
    mov     [K],ax  

    mov rax, 1
    mov rdi, 1
    mov rsi, EntrMsgn
    mov rdx, lenEntrn 
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64 
    cmp     EBX, 0   
    jne     StrToInt64.Error
    mov     [N],ax  

    mov rax, 1
    mov rdi, 1
    mov rsi, EntrMsgr 
    mov rdx, lenEntrr 
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64 
    cmp     EBX, 0   
    jne     StrToInt64.Error
    mov     [R],ax  

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, EntrMsgm ; адрес выводимой строки
    mov rdx, lenEntrm ; длина строки
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    mov     esi,InBuf  
    call    StrToInt64 
    mov     [M],ax

    mov ax,[K]
    cmp ax,0
    je  zero   

    mov    AX,[B] 
    imul   WORD[B]
    mov    BX,[F]
    sub    BX,2
    imul   BX
    idiv   WORD[K]
    mov    BX,AX; 
    mov    AX,[N]
    add    AX,[R]
    imul   WORD[M]
    sub    BX,AX
    mov    [X],BX

    jmp notzero
    zero:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ZeroMsg ; адрес выводимой строки
    mov rdx, lenZero; длина строки
    syscall
    jmp skipoutput
    notzero:

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit; длина строки
    syscall

    mov     esi, OutBuf  ; загрузка адреса буфера вывода 
    mov     ax, [X]      ; загрузка числа в регистр 
    cwde                 ; развертывание числа из ax в eax 
    call    IntToStr64

    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, rax ; длина строки
    mov rax, 1; системная функция 1 (write)
    ; вызов системной функции
    syscall
    skipoutput:
    ; read
    mov rax, 0; системная функция 0 (read)
    mov rdi, 0; дескриптор файла stdin=0
    mov rsi, InBuf; адрес вводимой строки
    mov rdx, lenIn; длина строки
    ; вызов системной функции
    syscall
    ; exit
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall
    ; вызов системной функции
%include "./lib64.asm"