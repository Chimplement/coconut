bits 16

disk: equ 0x0000

org 0x7c00 ; entry point
    jmp 0x0000:boot ; init code segment
boot:
    mov ax, 0x0000
    mov ds, ax ; init data segment
    mov ax, 0x1000
    mov ss, ax ; init stack segment

    mov [disk], dl ; save boot disk id

    mov sp, 0xffff ; init stack pointer

    mov ax, 3 ; set video mode 3
    int 0x10 ; video services

    mov si, loading_msg
    call putstr

    cli
    hlt

putstr: ; si: input_string
    mov ah, 0x0e ; write
.loop:
    lodsb
    cmp al, 0
    jz .ret

    int 0x10 ; video services
    jmp .loop
.ret:
    ret

loading_msg: db "bootport is loading...", 0

times 510 - ($-$$) db 0
magic: dw 0xaa55