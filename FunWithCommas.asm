section .data
	prompt1 db 'Enter next word or quit: ', 0
	format_in db '%s', 0
	safeword db 'quit', 0
	input db 256 dup (0)
	prev_input db 256 dup (0)
	runningstring db 1028 dup (0)
	comma db ', ', 0
	andword db ' and ', 0

section .bss
	pointherihardlyknowher resd 1
	wordcount resd 1
	prev_word_length resd 1

section .text
	global _main
	extern _printf, _scanf

_main:
	push ebp
	mov ebp, esp
	lea eax, [runningstring]
	mov [pointherihardlyknowher], eax
	mov dword [wordcount], 0
	mov dword [prev_word_length], 0

add_words:
	push prompt1
	call _printf
	add esp, 4
	lea eax, [input]
	push eax
	push format_in
	call _scanf
	add esp, 8
	lea esi, [input]
	lea edi, [safeword]

compare_loop:
	mov al, [esi]
	mov bl, [edi]
	cmp al, bl
	jne append_input
	test al, al
	jz the_very_end
	inc esi
	inc edi
	jmp compare_loop

append_input:
	mov edi, [pointherihardlyknowher]
	cmp dword [wordcount], 0
	je skip_comma
	lea esi, [comma]

copy_comma:
	mov al, [esi]
	mov [edi], al
	test al, al
	jz skip_comma
	inc esi
	inc edi
	jmp copy_comma

skip_comma:
	lea esi, [input]
	mov ecx, edi
	xor edx, edx

copy_loop:
	mov al, [esi]
	test al, al
	jz update_pointer
	mov [edi], al
	inc esi
	inc edi
	inc edx
	jmp copy_loop

update_pointer:
	mov [pointherihardlyknowher], edi
	mov [prev_word_length], edx
	lea esi, [input]
	lea edi, [prev_input]

backup_word:
	mov al, [esi]
	test al, al
	jz post_copy
	mov [edi], al
	inc esi
	inc edi
	jmp backup_word

post_copy:
	inc dword [wordcount]
	jmp add_words

the_very_end:
	cmp dword [wordcount], 1
	jle print_string
	mov edi, [pointherihardlyknowher]
	sub edi, 2
	sub edi, [prev_word_length]
	lea esi, [andword]

copy_and:
	mov al, [esi]
	mov [edi], al
	test al, al
	jz append_last_word
	inc esi
	inc edi
	jmp copy_and

append_last_word:
	lea esi, [prev_input]

copy_last_word:
	mov al, [esi]
	test al, al
	jz print_string
	mov [edi], al
	inc esi
	inc edi
	jmp copy_last_word

print_string:
	dec edi
	mov byte [edi], 0
	push runningstring
	call _printf
	add esp, 4
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret
