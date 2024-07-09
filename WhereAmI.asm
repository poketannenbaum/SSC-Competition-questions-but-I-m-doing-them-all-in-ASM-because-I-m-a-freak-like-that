section .data
    hello db 'Enter X and Y separated by a space: ', 0
    input db 256 dup (0)
    coord1 db 'The quadrant is: 1', 0
    coord2 db 'The quadrant is: 2', 0
    coord3 db 'The quadrant is: 3', 0
    coord4 db 'The quadrant is: 4', 0
    num1 dd 0
    num2 dd 0

section .text
global main
extern io_print_string, io_get_string

main:
    mov ebp, esp 
    push ebp
    mov ebp, esp
    mov eax, hello
    call io_print_string
    mov eax, input
    mov edx, 256
    call io_get_string
    mov edi, input
    call parse_number
    mov [num1], eax


    parse_space:
    movzx ecx, byte [edi]
    cmp ecx, ' '
    je space_found
    cmp ecx, 0
    je end_input
    inc edi
    jmp parse_space

    space_found:
    inc edi
    call parse_number
    mov [num2], eax
    mov eax, [num1]
    mov edx, [num2]
    cmp eax, 0
    jg check_y_positive
    jl check_y_negative
    jmp end

check_y_positive:
    cmp edx, 0
    jg print_quadrant_1
    jl print_quadrant_4
    jmp end

check_y_negative:
    cmp edx, 0
    jg print_quadrant_2
    jl print_quadrant_3
    jmp end

print_quadrant_1:
    mov eax, coord1
    call io_print_string
    add esp, 4
    jmp end

print_quadrant_2:
    mov eax, coord2
    call io_print_string 
    add esp, 4
    jmp end

print_quadrant_3:
    mov eax, coord3
    call io_print_string
    add esp, 4
    jmp end

print_quadrant_4:
    mov eax, coord4
    call io_print_string
    add esp, 4
    jmp end

parse_number:
    xor eax, eax
    xor ebx, ebx
    mov ebx, 1
    movzx ecx, byte [edi]
    cmp ecx, '-'
    jne check_digit
    mov ebx, -1
    inc edi

check_digit:
    xor eax, eax
    
start_parsing:
    movzx ecx, byte [edi]
    cmp ecx, ' '
    je parse_end
    cmp ecx, 0
    je parse_end
    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx
    inc edi
    jmp start_parsing

parse_end:
    imul eax, ebx
    mov ebx, 0
    ret

end:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

end_input:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret
