bits 16
org 0x7c00
    mov bp, -1 ; init stack
    mov sp, bp

    mov ax, 3 ; set video mode 3
    int 0x10 ; video services

    mov si, loading_msg
    call putstr

    cli
    hlt

putstr:
    mov ah, 0x0e ; write
.loop:
    lodsb
    cmp al, 0 ; end of string
    jz .ret

    int 0x10 ; video services
    jmp .loop
.ret:
    ret

loading_msg: db "bootport is loading...", 0

times 510 - ($-$$) db 0
magic: dw 0xaa55