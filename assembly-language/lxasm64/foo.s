bits 64
section .text
global _start

_start:
        mov eax, 1
        mov edx, 1
        sal eax, 11
        test eax, 8258559
        je ret0
        ;; exit 1
        mov rax, 60     ; sys_exit
        mov rdi, 1
        syscall
ret0:
        ;; exit 0
        mov rax, 60     ; sys_exit
        xor rdi, rdi
        syscall

;
;        ja      .L2        # 範囲外なので 0 返すところにゴー
;        movl    $1, %eax
;        movl    $1, %edx
;        sall    %cl, %eax  # 1 << (i - '0') を計算
;        testl   $8258559, %eax  # 0b11111100000001111111111 で bitmask
;        je      .L2        # ビット立ってなきゃ 0 を返す
;        popl    %ecx       # 1 返す
;        movl    %edx, %eax