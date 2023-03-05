section .data
; сегмент инициализированных переменных
; 6)
f1 dw 65535
f2 dd 65535

; 5)
; first dw 2500h
; second dw $0025
; third dd 100101b


; 4)
; value1 db 25
; double dd -35
; lat db "Emil"
; rus db "Эмиль"

; 2) A dw -30
; B dw 21

; 3) val1 db 255
; chart dw 256
; lue3 dw -128
; v5 db 10h
; min dw -32767
; ar dd 12345678h
; valar times 5 db 8
; ExitMsg db "Press Enter to Exit",10 ; выводимое сообщение9
; lenExit equ $-ExitMsg
; сегмент неинициализированных переменных
section .bss
; 2) X resd 1    

; 3) alu resw 10
; f1 resb 5
; InBuf resb 10 ; буфер для вводимой строки
; lenIn equ $-InBuf
section .text ; сегмент кода
global _start
_start:
    ; 6)
    mov AX, [f1]
    add AX, 1
    mov EBX, [f2]
    add EBX, 1
    ; 5)
    ; mov AX, [first]
    ; mov BX, [second]
    ; mov ECX, [third]

    ; 4)
    ; mov EAX, [value1]
    ; mov EAX, [double]
    ; mov EBX, [lat]
    ; mov EBX, [rus]

    ; 3) mov EAX, [val1]
    ; add EAX, [chart]
    ; mov [alu], EAX ; закидываем сумму в неинициализированную переменную
    ; mov EAX, [lue3]
    ; mov EAX, [v5]
    ; mov EAX, [min]
    ; mov EAX, [ar]
    ; mov EAX, [valar]
    ; mov EAX, [alu]

    ; 2) mov EAX,[A] ; загрузить число A в регистр EAX
    ; add EAX,5
    ; sub EAX,[B] ; вычесть число B, результат в EAX
    ; mov [X],EAX ; сохранить результат в памяти

    ; 1) ; write
    ; mov rax, 1 ; системная функция 1 (write)
    ; mov rdi, 1 ; дескриптор файла stdout=1
    ; mov rsi, ExitMsg ; адрес выводимой строки
    ; mov rdx, lenExit ; длина строки
    ; ; вызов системной функции
    ; syscall
    ; ; read
    ; mov rax, 0 ; системная функция 0 (read)
    ; mov rdi, 0 ; дескриптор файла stdin=0
    ; mov rsi, InBuf ; адрес вводимой строки
    ; mov rdx, lenIn ; длина строки
    ; ; вызов системной функции
    ; syscall
    ; exit
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall
    ; вызов системной функции