bits 16
%define ENTRY_POINT 0x7c00
%define BOOTHEADER ENTRY_POINT + 512

%include "bootheader.s"

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

    mov si, reading_header_msg
    call putstr

    mov ch, 0 ; cylinder
    mov dh, 0 ; head
    mov cl, 2 ; sector
    mov ax, cs ; destination
    mov es, ax
    mov al, 1 ; sector count
    mov bx, BOOTHEADER
    call read_sectors ; read sector containing the boot header
    jc .failed

    mov si, newline
    call putstr

    mov si, checking_header_msg
    call putstr

    cmp WORD [BOOTHEADER + bootheader_ident.magic], BOOTHEADER_MAGIC
    jne .failed

    mov si, newline
    call putstr

    mov si, checking_mode_msg
    call putstr
    
    cmp BYTE [BOOTHEADER + bootheader_ident.mode], BOOTHEADER_MODE16
    je .load16
    ; cmp WORD [BOOTHEADER + bootheader_ident.mode], BOOTHEADER_MODE32
    ; je .load32
    ; cmp WORD [BOOTHEADER + bootheader_ident.mode], BOOTHEADER_MODE64
    ; je .load64
    jmp .failed

.load16:
    mov si, detected_mode16_msg
    call putstrnl

.hlt:
    cli
    hlt

.failed:
    mov si, failed_msg
    call putstrnl
    jmp .hlt

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
; si: input_string
    call putstr
    mov si, newline
    call putstr
    ret

read_sectors:
; ch: cylinder
; dh: head
; cl: sector
; al: sector count
; es:bx: destination
    mov dl, [boot_disk]
    mov ah, 0x2 ; read sectors
    int 0x13 ; disk services
    ret

boot_disk: dw 0x0000

newline: db 0xA, 0xD, 0x0
failed_msg: db "failed", 0x0
reading_header_msg: db "reading header from disk...", 0x0
checking_header_msg: db "checking header...", 0x0
checking_mode_msg: db "checking mode...", 0x0
detected_mode16_msg: db "detected 16 bit mode", 0x0

times 510 - ($-$$) db 0
magic: dw 0xaa55