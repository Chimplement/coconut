bits 16
%define ENTRY_POINT 0x7c00

org ENTRY_POINT
    jmp 0x0000:.next ; init code segment
.next:
    mov ax, 0x0000
    mov ds, ax ; init data segment
    mov ax, 0x1000
    mov ss, ax ; init stack segment

    mov [boot_data.disk], dl ; save boot disk id

    mov sp, 0xffff ; init stack pointer

    mov ch, 0 ; cylinder
    mov dh, 0 ; head
    mov cl, 2 ; sector
    mov ax, 0x1000 ; destination
    mov es, ax
    mov bx, boot_data_size
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
    mov dl, [boot_data.disk]
    int 0x13 ; disk services
    ret

loading_msg: db "docking main module...", 0

struc boot_data
  .disk resw 1
endstruc

times 510 - ($-$$) db 0
magic: dw 0xaa55