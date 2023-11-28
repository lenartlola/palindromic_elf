[bits 64]

org     0x42000000

global _start

ehdr:
    db 0x7f, "ELF", 1, 1, 1, 0      ; e_ident
    times 8 db 0                    ; pad to e_entry
    dw 2                            ; e_type
    dw 3                            ; e_machine
    dd 1                            ; e_version
    dd _start                       ; e_entry
    ; dd phdr - $$                    ; e_phoff
    dd 52
    times 2 dd 0                    ; e_shoff, e_flags
    dw 52                     ; e_ehsize
    dw 32                     ; e_phentsize
    dw 1                            ; e_phnum
    times 3 dw 0                    ; e_shentsize, e_shnum, e_shstrndx

phdr:
    dd 1                            ; p_type
    dd 0                            ; p_offset
    dd $$                           ; p_vaddr
    dd $$                           ; p_paddr
    dd filesize                     ; p_filesz
    dd filesize                     ; p_memsz
    dd 5                            ; p_flags
    dd 0x1000                       ; p_align

; Just exit syscall in 32 bit
_start:
    ;; WRITE ;;
    ; push 0x426842
    ; 6842 4f42 0a90 9089 e1ba 0400
    dw 0x4268
    dw 0x424f
    db 0x0a
    ; push 0x0a424f42
    ; align bytes
    nop
    nop
    dw 0xe189
    dd 0x04ba
    db 0
    db 0xbb
    db 0x1, 0
    dw 0
    dd 0x04b8
    db 0
    db 0xcd
    db 0x80

    ;; ALIGN ;;
    times 3 nop

    ;; EXIT ;;
    dw 0x00b3
    dw 0x01b8
    dw 0
    db 0
    db 0xcd
    db 0x80

    ;;; MIRROR MODE ;;;
    ;; EXIT MIRROR ;;
    db 0x80
    db 0xcd
    db 0
    dw 0
    dw 0xb801
    dw 0xb300
    ; db 0

    ;; ALIGN MIRROR ;;
    times 3 nop

    ;; WRITE MIRROR ;;
    db 0x80
    db 0xcd
    db 0
    dw 0
    dd 0xb804
    db 0, 0x1
    db 0xbb
    db 0
    db 0
    db 0
    dw 0xba04
    dw 0x89e1
    nop
    nop
    db 0x0a
    dw 0x4f42
    dw 0x6842

mirror_phdr:
    dd 0x00100000
    dd 0x05000000
    dd 0xf4000000
    dd 0xf4000000
    dd 0x00000042
    dd 0x00000042
    dd 0
    dd 0x01000000

mirror_ehdr:
    times 3 dw 0
    db 0, 1
    db 0, 32
    db 0, 52
    times 2 dd 0
    dd 0x34000000
    dd 0x54000042
    dw 0
    db 0, 1
    db 0, 3
    db 0, 2                     ; reverse of e_type which is 0200 and we want 0002
    times 8 db 0
    db 0, 1, 1, 1, "FLE", 0x7f

filesize equ $ - $$
