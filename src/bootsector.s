bits 16
org 0x7c00
boot:
    mov si, message
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

message: db "Hello, world!", 0

times 510 - ($-$$) db 0
dw 0xaa55 ; magic number