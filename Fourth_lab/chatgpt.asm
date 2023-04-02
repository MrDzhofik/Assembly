section .data
matrix db 0, 0, 0
       db 0, 0, 0
       db 0, 0, 0
format db "%d", 0

section .text
global _start

_start:
    ; ввод матрицы
    mov ebx, matrix  ; адрес начала матрицы
    mov ecx, 9      ; количество элементов в матрице

input_loop:
    push ebx        ; сохранение адреса текущего элемента в стеке
    push format     ; указание формата ввода
    call scanf      ; вызов функции чтения данных

    add esp, 8      ; очистка стека от аргументов функции scanf
    add ebx, 1      ; переход к следующему элементу матрицы
    loop input_loop

    ; вывод матрицы
    mov ebx, matrix  ; адрес начала матрицы
    mov ecx, 3      ; количество строк в матрице
    mov edx, 3      ; количество столбцов в матрице

output_loop:
    push edx        ; сохранение количества столбцов в стеке
    push ebx        ; сохранение адреса начала строки в стеке
    push format     ; указание формата вывода
    call printf     ; вызов функции вывода данных

    add esp, 12     ; очистка стека от аргументов функции printf
    add ebx, 3      ; переход к началу следующей строки матрицы
    loop output_loop

    ; завершение программы
    mov eax, 1
    xor ebx, ebx
    int 0x80