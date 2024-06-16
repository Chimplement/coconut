bits 32
org 0x00f0

section code vstart=0x00f0

magic: dw 0x800f
mode: db 0x2

times 512 - ($-$$) db 0