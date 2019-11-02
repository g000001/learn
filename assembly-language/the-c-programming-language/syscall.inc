exit:
        mov rax, 60 ; sys_exit
        xor rdi, rdi ; 0
        syscall

;OutString:
;        push
;        mov edx, eax
;        inc eax ; sys_write (01)
;        mov edi, eax ; stdout (01)
;        syscall
;        pop
;        ret