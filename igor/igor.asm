global ccmp
global input
section .text

ccmp:
 ; пролог
 push rbp
 mov rbp, rsp
 push rax
 push rbx
 push rcx
 push rdx
 push rsi
 mov rsi, rdi ; 1 param
 pop rdi; 2 param
 mov rbx, rdx; 3 par
 mov rax, 0
 mov rdx, 0
 mov rcx, 255
 .cycle: 
 cld
 lodsb
 dec rsi
 cmp al, 0xA
 JE .break
 ; проверить на то, что нужно выгружать байт, а не слово
 cmpsb
 JE .add_char
 JMP .con
 .add_char:
 dec rsi
 lodsb
 mov byte[rbx + rdx], al
 inc rdx
 .con:
 loop .cycle
 .break
 ; эпилог
 mov rsp, rbp
 pop rbp
 ret
input:
 ; пролог
 push rbp
 mov rbp, rsp
 mov rsi, rdi; 1 par
 mov rax, 0
 mov rdi, 0
 mov rdx, 255
 syscall
 ; небольшая модификация введенной строки
 cld
 mov rcx, 255
 mov al, 0xA ; конец строки
 mov rdi, rsi
 repne scasb
 JE .found
 JMP .skip
 .found:
mov al, 0x0
rep lodsb
 .skip
 ; эпил
 mov rsp, rbp
 pop rbp
 ret 