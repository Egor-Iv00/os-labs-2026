.intel_syntax noprefix
.code16
.section .text
.global _start

.equ MAP_WIDTH, 21
.equ MAP_HEIGHT, 11
.equ MAP_SIZE, MAP_WIDTH * MAP_HEIGHT
.equ START_POSITION, MAP_WIDTH + 1

_start:
restart:
    mov WORD PTR [player_position], START_POSITION

redraw:
    mov ax, 0x0003
    int 0x10
    mov si, OFFSET logo
    call print_string
    mov si, OFFSET instructions
    call print_string

    mov si, OFFSET maze
    xor di, di
    mov cx, MAP_HEIGHT
print_row:
    push cx
    mov cx, MAP_WIDTH
print_cell:
    lodsb
    cmp di, WORD PTR [player_position]
    jne draw_cell
    mov al, '@'
draw_cell:
    call print_char
    inc di
    loop print_cell
    push si
    mov si, OFFSET newline
    call print_string
    pop si
    pop cx
    loop print_row

    mov bx, WORD PTR [player_position]
    cmp BYTE PTR [maze + bx], 'E'
    jne wait_key
    mov si, OFFSET win_message
    call print_string

wait_key:
    xor ah, ah
    int 0x16
    or al, 0x20
    cmp al, 'r'
    je restart

    mov bx, WORD PTR [player_position]
    cmp BYTE PTR [maze + bx], 'E'
    je wait_key

    cmp al, 'w'
    je move_up
    cmp al, 's'
    je move_down
    cmp al, 'a'
    je move_left
    cmp al, 'd'
    je move_right
    jmp wait_key

move_up:
    sub bx, MAP_WIDTH
    jmp try_move
move_down:
    add bx, MAP_WIDTH
    jmp try_move
move_left:
    dec bx
    jmp try_move
move_right:
    inc bx

try_move:
    cmp bx, MAP_SIZE
    jae wait_key
    cmp BYTE PTR [maze + bx], '#'
    je wait_key
    mov WORD PTR [player_position], bx
    jmp redraw

print_string:
    pusha
print_next:
    lodsb
    test al, al
    jz print_done
    call print_char
    jmp print_next
print_done:
    popa
    ret

print_char:
    pusha
    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    popa
    ret

player_position:
    .word START_POSITION
newline:
    .asciz "\r\n"
win_message:
    .asciz "You escaped! Press R to play again."
instructions:
    .ascii "EDU OS - MAZE\r\n"
    .ascii "WASD: move   R: restart\r\n"
    .asciz "@: player   #: wall   E: exit\r\n\r\n"

logo:
    .ascii "  +----------------------+\r\n"
    .ascii "  |  EEEE  DDD   U   U   |\r\n"
    .ascii "  |  E     D  D  U   U   |\r\n"
    .ascii "  |  EEE   D  D  U   U   |\r\n"
    .ascii "  |  E     D  D  U   U   |\r\n"
    .ascii "  |  EEEE  DDD    UUU    |\r\n"
    .ascii "  +----------------------+\r\n"
    .byte 0

maze:
    .ascii "#####################"
    .ascii "#             #     #"
    .ascii "# ##### ##### # ### #"
    .ascii "# #   #     #   #   #"
    .ascii "# # ####### ##### # #"
    .ascii "# #       #       ###"
    .ascii "# ####### ###### ## #"
    .ascii "#       #           #"
    .ascii "######### ######### #"
    .ascii "#                 E #"
    .ascii "#####################"
maze_end:
.if (maze_end - maze) != MAP_SIZE
.error "Map size must equal MAP_WIDTH * MAP_HEIGHT"
.endif

.org 8 * 512
