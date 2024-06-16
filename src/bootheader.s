%define BOOTHEADER_MAGIC 0x800f

%define BIOSINFO 0x0000

struc biosinfo
    .boot_disk: resb 1
endstruc

%define BOOTHEADER_MODE16 0x1
%define BOOTHEADER_MODE32 0x2

struc bootheader_ident
    .magic: resw 1
    .mode: resb 1
endstruc

struc bootheader_16
    .ident: resb bootheader_ident_size
    .entry: resw 1
    .code_segment: resw 1
    .code_sectors: resb 1
    .code_orgin: resw 1
    .data_segment: resw 1
    .data_sectors: resb 1
    .data_orgin: resw 1
    .stack_segment: resw 1
endstruc

struc bootheader_32
    .ident: resb bootheader_ident_size
endstruc