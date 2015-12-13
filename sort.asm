; Leander Metcalf
; 64-bit Self Development
; 13 December 2015
; Sorting positive integers

; Compiled on Mac osX
; nasm -f macho64 -g sort.asm && gcc -o sort sort.o

BITS 64

section .text ;section declaration

global _main
extern _exit

;int main (argv, argc)
_main:
    push    rbp
    mov     rbp, rsp
;   mov     rbx, [rbp+12*2]
;   sub     rsp, rbx

    lea     rdi, [rel array]
    mov     rax, array_size
    call    fn_sort ;returns number of passes to complete sort
    mov     rdi, rax
    call    _exit
    
;int fn_sort(*int array, int size)
fn_sort:
    push    rbp
    mov     rbp, rsp
    push    rbx
    sub     rsp, 8
    
    xor     rcx, rcx    ;local counter
    xor     rbx, rbx    ;temp
    xor     rdx, rdx    ;temp 2
    xor     rsi, rsi    ;early finish flag
    
.next_num:
    movzx   rbx, byte [rdi + rcx * 2]
    movzx   rdx, byte [rdi + 2 + rcx * 2]
    cmp     rbx, rdx
    jge     .bigger
    mov     [rdi + rcx * 2], dl
    mov     [rdi + 2 + rcx * 2], bl
    inc     rsi
.bigger:
    inc     rcx
    cmp     rcx, rax
    jl      .next_num
    add     [rsp], dword 1
    test    rsi, rsi
    jz      .fn_early_finish
    dec     rax
    xor     rcx, rcx
    xor     rsi, rsi
    cmp     rax, 0
    jnz     .next_num
.fn_early_finish:
    mov     rax, [rsp]
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret
    
section .data ;section declaration
array: dw 9,5,8,22,3,0,2,1,7,6,4,17,95,3,0,0,7,6,21,200
array_size: equ $ - array
