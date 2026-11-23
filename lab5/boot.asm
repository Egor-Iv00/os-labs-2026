.intel_syntax noprefix
.code16
.section .text
.global _start

_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    cld

    mov ax, 0x0003
    int 0x10

    mov si, OFFSET logo
    call print_string
    mov si, OFFSET title
    call print_string
    mov si, OFFSET question
    call print_string

read_answer:
    xor ah, ah
    int 0x16

    cmp al, 'y'
    je answer_yes
    cmp al, 'Y'
    je answer_yes
    cmp al, 'n'
    je answer_no
    cmp al, 'N'
    je answer_no

    mov si, OFFSET invalid_answer
    call print_string
    jmp read_answer

answer_yes:
    call print_char
    mov si, OFFSET yes_message
    jmp show_answer

answer_no:
    call print_char
    mov si, OFFSET no_message

show_answer:
    call print_string

halt:
    cli
    hlt
    jmp halt

print_string:
    lodsb
    test al, al
    jz print_done
    call print_char
    jmp print_string
print_done:
    ret

print_char:
    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    ret

logo:
    .ascii "\r\n"
    .ascii "  +----------------------+\r\n"
    .ascii "  |  EEEE  DDD   U   U   |\r\n"
    .ascii "  |  E     D  D  U   U   |\r\n"
    .ascii "  |  EEE   D  D  U   U   |\r\n"
    .ascii "  |  E     D  D  U   U   |\r\n"
    .ascii "  |  EEEE  DDD    UUU    |\r\n"
    .ascii "  +----------------------+\r\n"
    .byte 0

title:
    .asciz "\r\n  EDU OS\r\n  Operating Systems - Lab 5\r\n"
question:
    .asciz "\r\n  Do you like assembly? [y/n] "
invalid_answer:
    .asciz "\r\n  Please press Y or N: "
yes_message:
    .asciz "\r\n  Great! Let's learn more.\r\n"
no_message:
    .asciz "\r\n  That's OK. Keep trying!\r\n"

.org 510
.word 0xAA55
