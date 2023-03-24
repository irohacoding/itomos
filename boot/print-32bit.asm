;===============================================
; print-32bit.asm
;-----------------------------------------------
[bits 32]

	VIDEO_MEMORY equ 0xb8000
	WHITE_OB_BLACK equ 0x0f

print_32bit:
	pusha
	mov edx, VIDEO_MEMORY

print_32bit_loop:
	mov al, [ebx]
	mov ah, WHITE_OB_BLACK

	cmp al, 0
	je print_32bit_done

	mov [edx], ax
	add ebx, 1
	add edx, 2

	jmp print_32bit_loop

print_32bit_done:
	popa
	ret
;===============================================
