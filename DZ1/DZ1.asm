section .data
; сегмент инициализированных переменных
ExitMsg db "Result: ",10
lenExit equ $-ExitMsg
EnterMsg db "Enter string:",10
lenM equ $-EnterMsg
; сегмент неинициализированных переменных
section .bss
; буфер для вводимой строки
InBuf resb 100
lenIn equ $-InBuf
section .text ; сегмент кода
global _start
_start:
    ; write
    mov rax, 1 ; системная функция 4 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, EnterMsg ; адрес выводимой строки
    mov rdx, lenM ; длина выводимой строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 ; системная функция 3 (read)
    mov rdi, 0 ; дескриптор файла stdin=0
    mov rsi, InBuf ; адрес буфера ввода
    mov rdx, lenIn ; размер буфера
    syscall ; вызов системной функции
    ; подсчет длины введенной строки до кода Enter
    lea rdi, [InBuf] ; загружаем адрес строки в edi
    mov rcx,lenIn ; загружаем размер буфера ввода
    mov al,' ' ; загружаем в al пробел для поиска
    mov ebx,0 ; обнуляем счетчик пробелов
    cld
    
cic1:
    AND BX, 1; выполнить операцию AND с маской 1
    JNZ pod_swap ; перейти к метке swap (если результат не равен 0)
    scasb ; проверяем очередной символ на пробел
    je consl ; если пробел - меняем местами символы
    jmp exit

pod_swap: 
    mov r9, 5 ; длина словa - 1
    push rcx
    mov rcx, 3 ; загружаем количество повторений - длина слова / 2
    jmp swap

swap:
    push rcx
    mov al, BYTE[rdi+r9]
    mov cl, BYTE[rdi]
    mov [rdi], al
    mov [rdi+r9], cl
    sub r9, 2
    inc rdi
    pop rcx
    loop swap
    mov ebx, 0; обнуляем счетчик пробелов
    add rdi, 4; переходим к следующему слову
    mov al, ' '
    pop rcx
    loop cic1
   
consl: inc ebx ; иначе - увеличиваем счетчик слов

exit: loop cic1
    push rsi
    ;write text
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, ExitMsg
    mov rdx, lenExit ; длина строки
    syscall ; вызов системной функции

    ;write modified string
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    pop rsi
    mov rdx, lenIn ; длина строки
    syscall ; вызов системной функции

    ; exit
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; код возврата 0
    syscall ; вызов системной функции завершения