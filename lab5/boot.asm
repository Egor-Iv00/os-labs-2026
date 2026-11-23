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
    mov BYTE PTR [boot_drive], dl

    xor ah, ah
    int 0x13
    jc disk_error

    mov ax, 0x0208
    mov bx, 0x8000
    mov cx, 0x0002
    xor dh, dh
    mov dl, BYTE PTR [boot_drive]
    int 0x13
    jc disk_error

    ljmp 0x0000, 0x8000

disk_error:
    mov si, OFFSET error_message
print_error:
    lodsb
    test al, al
    jz halt
    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    jmp print_error
halt:
    cli
    hlt
    jmp halt

boot_drive:
    .byte 0
error_message:
    .asciz "Disk read error"

.org 510
.word 0xAA55
