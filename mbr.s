	bits 16
	org 0x7c00

	KERNEL_OFFSET equ 0x1000

	jmp start

	%include "print.s"
	%include "disk.s"
	%include "gdt.s"
	%include "switch-32.s"

	bits 16
start:	
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x9000
	mov bp, sp

	mov [BOOT_DRIVE], dl

	call load_kernel
	call switch_32

	jmp $

load_kernel:
	mov dl, [BOOT_DRIVE]	;drive
	mov si, dap
	call disk_load
	ret

	align 4
dap:
	db 16			;packet size
	db 0			;reserved
	dw 5			;num sectors
	dw KERNEL_OFFSET	;buffer
	dw 0x0000		;buffer segment
	dq 1			;lba

	bits 32
BEGIN_32BIT:
	call KERNEL_OFFSET
	jmp $

	BOOT_DRIVE db 0
	
	times 510-($-$$) db 0
	dw 0xaa55
