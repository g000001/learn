;(defun z ()
;  (LET ((LOOP-REPEAT (CEILING (* 10000 10000))))
;    (DECLARE (TYPE INTEGER LOOP-REPEAT))
;    (labels ((NEXT-LOOP ()
;               (IF (<= LOOP-REPEAT 0)
;                   (return-from next-loop)
;                   (LET* ((G 1) (NEW (- LOOP-REPEAT G)))
;                     (SETQ LOOP-REPEAT NEW)))
;               (NEXT-LOOP)))
;      (next-loop)))
;  0)
;
;
; disassembly for Z
; 18998584:       B90008AF2F       MOV ECX, 800000000         ; no-arg-parsing entry point
;       89:       EB1A             JMP L2
;       8B:       90               NOP
;       8C:       90               NOP
;       8D:       90               NOP
;       8E:       90               NOP
;       8F:       90               NOP
;       90: L0:   4883F900         CMP RCX, 0
;       94:       7F0B             JNLE L1
;       96:       BA17001020       XOR EDX, EDX
;       9B:       488BE5           MOV RSP, RBP
;       9E:       F8               CLC
;       9F:       5D               POP RBP
;       A0:       C3               RET
;       A1: L1:   4883E908         SUB RCX, 8
;       A5: L2:   EBE9             JMP L0
;       A7:       CC0A             BREAK 10                   ; error trap
;       A9:       02               BYTE #X02
;       AA:       18               BYTE #X18                  ; INVALID-ARG-COUNT-ERROR
;       AB:       54               BYTE #X54                  ; RCX

; nasm -f elf64 loop-100000000.s
; ld -s -o loop-100000000 loop-100000000.o

bits 64
section .text
global _start

_start:
        mov ecx, 100000000         ; no-arg-parsing entry point
        jmp L2
L0:
        cmp rcx, 0
        jnle L1

        ;; exit 0
        mov rax, 60     ; sys_exit
        xor rdi, rdi    ; 0
        syscall
L1:
        sub rcx, 1
L2:
        jmp L0

