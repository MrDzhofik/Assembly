%include "../lib64.asm"

section .data
    StartMsg db "Enter 6*4 matrix:", 10
    StartLen equ $-StartMsg
    NewLine: db 0xA
    ResultMsg db "Result:", 10
    ResultLen equ $-ResultMsg

    Space db "  "

section .bss
    matrix times 24 resd 1
    sums   times 6       resd 6

    OutBuf resw 1
    lenOut equ $-OutBuf
    InBuf resq 10
    lenIn equ $-InBuf


section .text
global _start

_start:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, StartLen ; длина строки
    syscall; вызов системной функции

    mov rcx, 6
    xor rdi, rdi

read_line:
    push rcx
    push rdi

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall

    pop rdi
    mov rcx, rax ; Сохраням длину строки
    xor rdx, rdx ; Обнуляем регистр
    xor r8, r8 ; Обнуляем регистр

process_line:
    cmp byte[InBuf + rdx], 10; Если конец строки то обрабатываем число
    je process_number

    cmp byte[InBuf + rdx], ' '; Если был не конец, и следующий символ 
    jne next; не пробел, то продолжаем считывание

    mov byte[InBuf + rdx], 10; Помещаем вместо пробела \n
    cmp r8, rdx; Если длина строки не совпадает с предыдущей
    jne process_number
    jmp next

process_number:
    push rdx

    call StrToInt64

    mov [matrix + 4 * rdi], rax; Помещаем результат в матрицу
    inc rdi; увеличиваем счетчик введенных чисел

    pop rdx
    mov r8, rdx; Теперь считывать следующее число надо начинать с 
    inc r8; окончания длины предыдущего
    lea rsi, [InBuf + r8]; Передаем указатель на смещенный буфер

next:
    inc rdx; Увеличиваем длину числа
    loop process_line

    pop rcx

    dec rcx
    cmp rcx, 0
    jnz read_line 
    
    mov rcx, 6
    mov rdi, 0
    mov rdx, 0; Обнуляем подсчет текущей строки

sum_row:
    push rcx
    mov rax, 0
    mov rcx, 4

add_elem:
    add rax, [matrix + 4 * rdx]
    inc rdx
    loop add_elem
    pop RCX
    mov [sums + 4 * rdi], rax
    inc rdi
    loop sum_row

output:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ResultMsg ; адрес выводимой строки
    mov rdx, ResultLen ; длина строки
    syscall; вызов системной функции

    xor rbx, rbx; Обнуляем регистры
    xor rdx, rdx

    mov rcx, 6
check:
    push rcx
    mov eax, [sums + 4 * rbp] ; массив сумм строк
    inc rbp
    cmp rcx, 0
    je exit
    cmp eax, 0 ; проверяем какая сумма элементов строки
    JGE output_row
    add rbx, 4 ; если отрицательное, то смещаем регистр на количество столбцов
    pop rcx
    loop check
    jmp exit

output_row:
    mov rcx, 4
output_column:
    push rcx
    mov rsi, OutBuf
    mov eax, [matrix + 4 * rbx]
    inc rbx
    call IntToStr64

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции

    mov rax, 1
    mov rdi, 1
    mov rsi, Space; адрес строки с пробелом
    mov rdx, 1
    syscall

    pop rcx
    loop output_column

    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, NewLine ; адрес выводимой строки
    mov rdx, 1 ; длина строки
    syscall; вызов системной функции

    pop rcx
    dec rcx
    jmp check

exit:
    xor rdi, rdi
    mov rax, 60
    syscall

