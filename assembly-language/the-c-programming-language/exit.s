        ;; exit 0
        mov rax, 60 ; sys_exit
        xor rdi, rdi ; 0
        syscall