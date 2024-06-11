%define BOOTHEADER_MAGIC 0x800f

%define BOOTHEADER_MODE16 0x1

struc bootheader_ident
    .magic: resw 1
    .mode: resb 1
endstruc

struc bootheader_16
    .ident: resb boot_header_ident_size
    .sectors: resw 1
    .orgin: resw 1
    .entry: resw 1
endstruc