; nasm -f elf64 case.s
; ld -s -o case case.o

bits 64
section .text
global _start

_start:
        mov rcx, 1              ;アイテム=番号
        lea rax, [item2-item1]  ;ジャンプ命令の幅
        mul rcx                 ;番号*幅 => 飛ぶ距離
        lea rdx, [item1+rax]    ;飛び先の番地
        jmp rdx
item1:
        lea rdx, [a]
        jmp rdx
item2:
        lea rdx, [b]
        jmp rdx
        lea rdx, [c]
        jmp rdx
        lea rdx, [d]
        jmp rdx
a:
        ;; exit 0
        mov rax, 60     ; sys_exit
        mov rdi, 0
        syscall
b:
        ;; exit 0
        mov rax, 60     ; sys_exit
        mov rdi, 1
        syscall
c:
        ;; exit 0
        mov rax, 60     ; sys_exit
        mov rdi, 2
        syscall
d:
        ;; exit 0
        mov rax, 60     ; sys_exit
        mov rdi, 3
        syscall
