;===============================================
; boot.asm
;-----------------------------------------------
[bits 16]
	; [mov] data transfer instruction
	; [ax] accumulator (general-purpose register)
	; [0x07c0] memory location
	mov ax, 0x07c0
	; [mov] data transfer instruction
	; [ds] 16-bit segment register
	; [ax] accumulator (general-purpose register)
	mov ds, ax

	; [mov] data transfer instruction
	; [si] source index register
	; [msg] label
	mov si, msg
	; [cld] clear direction flag
	cld

; [ch_loop:] label
ch_loop:
	; [lodsb] load byte at address ds:si into al
	lodsb
	or al, al
	jz hang
	mov ah, 0x0E
	mov bh, 0
	int 0x10
	jmp ch_loop

; [hang:] label
hang:
	jmp hang

; [msg] label
msg	db 'hello, this is itomos!', 13, 10, 0

	; [-] ordinary subtraction
	; [$] the assembly position at the begining
	;     of the line containing the expression
	; [$$] the begining of the current section
	times 510-($-$$) db 0
	db 0x55
	db 0xAA
;===============================================
