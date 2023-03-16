;===============================================
; boot.asm
;-----------------------------------------------
; [[bits 16]] use 16 bits
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
	; [or] machine instruction
	; [al] 8-bit register (8 high bits of ax)
	or al, al
	; [jz] jump if zero
	; [hang] label
	jz hang
	; [mov] data transfer instruction
	; [ah] 8-bit register (8 low bits of ax)
	; [0x0E] 14 in decimal, scrolling teletype BIOS routine
	mov ah, 0x0E
	; [mov] data transfer instruction
	; [bh] 8-bit register (8 low bits of bx) bx is base register
	mov bh, 0
	; [int] interrupt handler
	; [0x10] 16 in decimal, print out the character
	int 0x10
	; [jmp] jump to a label
	; [ch_loop] label
	jmp ch_loop

; [hang:] label
hang:
	; [jmp] jump to a label
	; [hang] label
	jmp hang

; [msg:] label
msg:
	; [db] define byte (8 bits)
	; ['hello, this is itomos!'] string constant
	; [13] ascii character CR (carriage return)
	; [10] ascii character LF (line feed)
	; [0] 0 for string ends
	db 'hello, this is itomos!', 13, 10, 0

	; [times] assemble multiple times
	; [510] 510 bytes
	; [-] ordinary subtraction
	; [$] the assembly position at the begining
	;     of the line containing the expression
	; [$$] the begining of the current section
	; [0] 0 for fills bootloader with zero padding
	times 510-($-$$) db 0
	; [db] define byte (8 bits)
	; [0x55] boot sector signature
	db 0x55
	; [db] define byte (8 bits)
	; [0xAA] boot sector signature
	db 0xAA
;===============================================
