CR0_WP equ 0x00010000
CR0_PG equ 0x80000000
CR4_PSE equ 0x00000010
	
MBALIGN equ 1 << 0
MEMINFO equ 1 << 1
MBFLAGS equ MBALIGN | MEMINFO
MAGIC equ 0x1badb002
CHECKSUM equ -(MAGIC + MBFLAGS)

section .multiboot.data
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

section .early_stack
align 16
stack_bottom:
	resb 16384
stack_top:

section .bss
align 4096
boot_pagedir:
	resb 4096
boot_pagetable:
	resb 4096

section .multiboot.text
global _start
_start:
	lgdt [gdt_descriptor]
	jmp CODE_SEG:.jump
.jump:
	mov ecx, eax		;save magic
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, stack_top

	mov eax, boot_pagedir
	mov cr3, eax
	mov eax, cr4
	or eax, CR4_PSE
	mov cr4, eax
	mov eax, cr0
	or eax, CR0_PG | CR0_WP
	mov cr0, eax

	lea eax, high
	jmp eax
	
section .text
high:	
	mov eax, ecx
	push dword 0
	popf
	push eax		;multiboot magic
	push ebx		;multiboot_info_t*
	extern kmain
	call kmain

	cli
.1:
	hlt
	jmp .1
.end:

%include "arch/x86/gdt.s"
