;===============================================
; boot.asm
;-----------------------------------------------
[bits 16]
	; mov: data transfer instruction
	; ax: general-purpose register (GPR)
	; 0x07c0: memory location
	mov ax, 0x07c0
	; mov: data transfer instruction
	; ds: 16-bit segment register
	; ax: general-purpose register (GPR)
	mov ds, ax

	mov si, msg
	cld

ch_loop:
	lodsb
	or al, al
	jz hang
	mov ah, 0x0E
	mov bh, 0
	int 0x10
	jmp ch_loop

hang:
	jmp hang

msg	db 'hello, this is itomos!', 13, 10, 0

	times 510-($-$$) db 0
	db 0x55
	db 0xAA
;===============================================
