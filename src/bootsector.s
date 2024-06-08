bits 16
%define ENTRY_POINT 0x7c00
%define MAIN_MODULE ENTRY_POINT + 512

org ENTRY_POINT
    jmp 0x0000:.next ; init code segment
.next:
    mov ax, 0x0000
    mov ds, ax ; init data segment
    mov ax, 0x1000
    mov ss, ax ; init stack segment

    mov sp, 0xffff ; init stack pointer

    mov [boot_disk], dl ; save boot disk id

    mov ax, 3 ; set video mode 3
    int 0x10 ; video services

    mov si, loading_msg
    call putstrnl

    mov ch, 0 ; cylinder
    mov dh, 0 ; head
    mov cl, 2 ; sector
    mov ax, cs ; destination
    mov es, ax
    mov bx, MAIN_MODULE
    call read_sector ; read first sector of main module

    cli
    hlt

putstr:
; si: input_string
    mov ah, 0x0e ; write
.loop:
    lodsb
    cmp al, 0x0
    jz .ret

    int 0x10 ; video services
    jmp .loop
.ret:
    ret

putstrnl:
    call putstr
    mov si, newline
    call putstr
    ret

read_sector:
; ch: cylinder
; dh: head
; cl: sector
; es:bx: destination
    mov ah, 0x2 ; read sectors
    mov al, 1 ; sector count
    mov dl, [boot_disk]
    int 0x13 ; disk services
    ret

boot_disk: dw 0x0000

newline: db 0xA, 0xD, 0x0
loading_msg: db "docking main module...", 0x0

times 510 - ($-$$) db 0
magic: dw 0xaa55