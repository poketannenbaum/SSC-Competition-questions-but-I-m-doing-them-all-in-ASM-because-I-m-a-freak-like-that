section .data
    prompt1 db 'Enter the KW hours used: ', 0
    prompt2 db 'Amount owed is $%.5f', 10, 0
    format_in db '%d', 0
    KWHOURS dd 0
    RATEPR1K dd 0.07633
    RATEPO1K dd 0.09259
    PHOWE dd 76.33

section .bss
    OWED resq 1

section .text
    global _main
    extern _printf, _scanf

_main:
    push prompt1
    call _printf
    add esp, 4
    push KWHOURS
    push format_in
    call _scanf
    add esp, 8
    mov eax, [KWHOURS]
    cmp eax, 1000
    jle use_rate_pr1k
    sub eax, 1000
    mov [KWHOURS], eax
    fild dword [KWHOURS]
    fld dword [RATEPO1K]
    fmulp st1, st0
    fstp qword [OWED]
    fld dword [PHOWE]
    fadd qword [OWED]
    fstp qword [OWED]
    jmp display_amount

use_rate_pr1k:
    fild dword [KWHOURS]
    fld dword [RATEPR1K]
    fmulp st1, st0
    fstp qword [OWED]

display_amount:
    fld qword [OWED]
    sub esp, 8
    fstp qword [esp]
    push prompt2
    call _printf
    add esp, 12
    xor eax, eax
    ret
