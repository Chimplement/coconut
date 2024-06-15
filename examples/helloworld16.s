bits 16
org 0x00f0

section code vstart=0x00f0

magic: dw 0x800f
mode: db 0x1
entry: dw start
code_segment: dw 0x0000
code_sectors: db 1
code_orgin: dw 0x00f0
data_segment: dw 0x1000
data_sectors: db 1
data_orgin: dw 0x00f0
stack_segment: dw 0xf000

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

times 512 - ($-$$) db 0

section data vstart=0x00f0

msg: db "Hello, World!", 0x0

times 512 - ($-$$) db 0