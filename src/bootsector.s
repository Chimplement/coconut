bits 16
org 0x7c00 ; entry point

section BOOTSECTOR start=0x7c00
    jmp 0x0000:$ ; init code segment
    mov ax, 0x1000
    mov ds, ax ; init data segment
    mov ax, 0x2000
    mov ss, ax ; init stack segment

    mov [disk], dl ; save boot disk id

    mov sp, 0xffff ; init stack pointer

    mov ch, 0 ; cylinder
    mov dh, 0 ; head
    mov cl, 2 ; sector
    mov ax, 0x1000 ; destination
    mov es, ax
    mov bx, 0x0000
    call read_sector ; read DATASECTOR

    mov ax, 3 ; set video mode 3
    int 0x10 ; video services

    mov si, loading_msg
    call putstr

    cli
    hlt

putstr:
; si: input_string
    mov ah, 0x0e ; write
.loop:
    lodsb
    cmp al, 0
    jz .ret

    int 0x10 ; video services
    jmp .loop
.ret:
    ret

read_sector:
; ch: cylinder
; dh: head
; cl: sector
; es:bx: destination
    mov ah, 0x2 ; read sectors
    mov al, 1 ; sector count
    mov dl, [disk]
    int 0x13 ; disk services
    ret

times 510 - ($-$$) db 0
magic: dw 0xaa55

section DATASECTOR follows=BOOTSECTOR vstart=0x0000
disk: resw 1
loading_msg: db "bootport is loading...", 0