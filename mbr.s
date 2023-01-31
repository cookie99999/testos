	bits 16
	org 0x7c00

	KERNEL_OFFSET equ 0x1000

	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax

	mov [BOOT_DRIVE], dl
	
	mov bp, 0x9000
	mov sp, bp

	call load_kernel
	call switch_32

	jmp $

	%include "disk.s"
	%include "gdt.s"
	%include "switch-32.s"

	bits 16
load_kernel:
	mov bx, KERNEL_OFFSET	;dest
	mov dh, 2		;num sectors
	mov dl, [BOOT_DRIVE]	;drive
	call disk_load
	ret

	bits 32
BEGIN_32BIT:
	call KERNEL_OFFSET
	jmp $

	BOOT_DRIVE db 0
	
	times 510-($-$$) db 0
	dw 0xaa55
