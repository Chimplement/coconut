bits 16
org 0x00f0

magic: dw 0x800f
mode: db 0x1
sectors: db 0x1
orgin: dw 0x00f0
entry: dw start

start:
    mov si, msg
    mov ah, 0x0e ; write
.loop:
    lodsb
    cmp al, 0x0
    jz .hlt

    int 0x10 ; video services
    jmp .loop
.hlt:
    cli
    hlt

msg: db "Hello, World!", 0x0