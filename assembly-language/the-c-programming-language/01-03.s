;#include <stdio.h>
;
;main () {
;  float fahr, cels;
;
;  /* title */
;  printf("fahrenheit\tcelsius\n");
;
;  fahr = 0;
;  while (fahr <= 300) {
;    cels = (5.0 / 9.0) * (fahr - 32);
;    printf("%8.0f\t%6.1f\n", fahr, cels);
;    fahr = fahr + 20;
;  }
;}
%include "syscall.inc"

bits 64
section .text
global _start

_start:
        xor     rax, rax
        mov     rdx, rax
        mov     al, 1       ; write syscall
        mov     rdi, rax    ; stdout    (01)
        mov     dl, titlelen     ; length    (13)
        mov     rsi, title    ; address
        syscall
        mov r15, 5
L0:
        xor     rax, rax
        mov     rdx, rax
        mov     al, 1       ; write syscall
        mov     rdi, rax    ; stdout    (01)
        mov     dl, msglen     ; length    (13)
        mov     rsi, msg    ; address
        syscall
        cmp     r15, 0
        jnle    L1
        call    exit
L1:
        sub     r15, 1
        jmp     L0

section .data
        title db 'fahrenheit	celsius', 0x0a
        titlelen equ $ - title
        msg db 'hello, world', 0x0a
        msglen equ $ - msg