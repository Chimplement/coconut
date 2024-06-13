%define BOOTHEADER_MAGIC 0x800f

%define BIOSINFO 0x0000

struc biosinfo
    .boot_disk: resb 1
endstruc

%define BOOTHEADER_MODE16 0x1

struc bootheader_ident
    .magic: resw 1
    .mode: resb 1
endstruc

struc bootheader_16
    .ident: resb bootheader_ident_size
    .sectors: resb 1
    .orgin: resw 1
    .entry: resw 1
    .segment: resw 1
endstruc