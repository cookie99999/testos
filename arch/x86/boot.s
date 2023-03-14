MBALIGN equ 1 << 0
MEMINFO equ 1 << 1
MBFLAGS equ MBALIGN | MEMINFO
MAGIC equ 0x1badb002
CHECKSUM equ -(MAGIC + MBFLAGS)

section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

section .bss
align 16
stack_bottom:
	resb 16384
stack_top:

section .text
global _start:function (_start.end - _start)
_start:
	lgdt [gdt_descriptor]
	jmp CODE_SEG:.jump
.jump:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, stack_top
	extern kmain
	call kmain

	cli
.1:
	hlt
	jmp .1
.end:

%include "arch/x86/gdt.s"
