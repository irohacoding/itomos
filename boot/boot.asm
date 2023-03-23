;===============================================
; boot.asm
;-----------------------------------------------
; Reference site:
; https://github.com/cfenollosa/os-tutorial
;-----------------------------------------------
[bits 16]
[org 0x7c00]

	KERNEL_OFFSET equ 0x1000

boot:
	jmp main
	times 3-($-$$) db 0x90

main:
	xor ax, ax
	mov ds, ax
	mov sp, bp
	mov bp, 0x8000

	mov bx, MSG_REAL_MODE
	call print
	call print_nl

	call load_kernel
	call switch_to_32bit
	jmp $

%include "boot/print.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/print-32bit.asm"
%include "boot/switch-to-32bit.asm"

;-----------------------------------------------
[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print
	call print_nl

	mov dh, [NUM_SECTORS]

	mov bx, 0
	mov es, bx

	mov bx, KERNEL_OFFSET
	call disk_load
	ret

;-----------------------------------------------
[bits 32]
BEGIN_32BIT:
	mov ebx, MSG_PROT_MODE
	call print_string_32bit
	call KERNEL_OFFSET
	jmp $

;-----------------------------------------------
NUM_SECTORS: db 0x01

MSG_REAL_MODE db "Started in 16-bit REAL MODE", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

;-----------------------------------------------
times 510-($-$$) db 0
dw 0xaa55
;===============================================
