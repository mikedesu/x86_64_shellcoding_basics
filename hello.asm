; hello world x86_64 nasm

global main 

section .text

main:

;; push 'H' '\n' to the stack,
;; load the stack pointer in for a call to write
xor     rax, rax
xor     rsi, rsi
xor     rdx, rdx
mov     al,  1
mov     sil, 1
push    10
push    72
mov     rsi, rsp
mov     dl,  14
syscall

;; call exit
xor     rax, rax
mov     al,  60
xor     edi, edi
syscall

