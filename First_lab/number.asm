section .data
; сегмент инициализированных переменных
    A db 5
    B db 15

section .bss
    C resb 1

section .text ; сегмент кода
global _start
_start:
    mov AX, [A]
    add AX, [B]
    mov [C], AX

    ; exit
    mov EAX, 60 ; системная функция 60 (exit)
    xor EDI, EDI ; return code 0
    syscall
    ; вызов системной функции