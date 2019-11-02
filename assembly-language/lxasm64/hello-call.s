;;------------------------------------
;; hello.s
;;   nasm -f elf64 hello.s
;;   ld -o hello01 hello.o
;;   ./hello
;;------------------------------------
;
;bits 64
;section .text
;global _start
;
;OutString:
;        push rax
;        mov edx, eax
;        inc eax ; sys_write (01)
;        mov edi, eax ; stdout (01)
;        syscall
;        pop rax
;        ret
;
;_start:
;        mov     dl, len     ; length    (13)
;        mov     rsi, msg    ; address
;        call OutString
;
;        xor     edi, edi    ; return 0
;        mov     eax, edi
;        mov     al, 60      ; sys_exit
;        syscall
;
;section .data
;        msg     db      'hello, world', 0x0A
;        len     equ     $ - msg
;
;
;------------------------------------
; hellol.s
;   nasm -f elf64 hellol.s
;   ld -o hellol hellol.o
;   ./hellol
;------------------------------------

bits 64
section .text
        extern printf

global _start

write:
        mov rax, 1      ; sys_write
        mov rdi, 1      ; stdout
        syscall
        ret
exit:
        mov rax, 60     ; sys_exit
        xor rdi, rdi    ; 0
        syscall
        ret
_start:
        mov rsi, msg    ; address
        mov rdx, len    ; length (13)
        call write

        mov rsi, msg2    ; address
        mov rdx, len2    ; length (13)
        call write

        mov rax, 3
        call _printf

        call exit


section .data
        msg     db      'hello, world', 0x0A
        len     equ     $ - msg
        msg2     db      'hello, world2', 0x0A
        len2     equ     $ - msg2