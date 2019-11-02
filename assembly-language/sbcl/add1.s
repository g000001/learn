;------------------------------------
; add1.s
;   nasm -f elf64 xxx.s
;   ld -o hello01 xxx.o
;   ./add1
;------------------------------------

bits 64
section .text
global _start

OutString:
        push rax
        mov edx, eax
        inc eax ; sys_write (01)
        mov edi, eax ; stdout (01)
        syscall
        pop rax
        ret

add1:
        add     rax, 10
;        push rbp
;        mov     rsp, rbp
;        clc
;        pop     rbp
        ret

_start:
;        sub rsp, 24
        mov rax, 0
        call    add1

exit:
        mov     rdi, rax    ; return 1
        mov     rax, 60      ; sys_exit
        syscall


section .data
        msg     db      'hello, world', 0x0A
        len     equ     $ - msg