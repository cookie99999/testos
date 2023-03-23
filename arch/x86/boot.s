.set CR0_WP, 0x00010000
.set CR0_PG, 0x80000000
.set CR4_PSE, 0x00000010
	
.set MBALIGN, 1 << 0
.set MEMINFO, 1 << 1
.set MBFLAGS, MBALIGN | MEMINFO
.set MAGIC, 0x1badb002
.set CHECKSUM, -(MAGIC + MBFLAGS)

.section .multiboot.data, "aw"
.align 4
.long MAGIC
.long MBFLAGS
.long CHECKSUM

.section .early_stack, "aw", @nobits
stack_bottom:
	.skip 16384
stack_top:

.section .bss, "aw", @nobits
.align 4096
boot_pagedir:
	.skip 4096
boot_pagetable:
	.skip 4096

.section .multiboot.text, "a"
	.global _start
	.type _start, @function
_start:
	lgdt (gdt_descriptor)
	ljmp $CODE_SEG, $.jump
.jump:
	movl %eax, %ecx		#save magic
	movw $DATA_SEG, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	movw %ax, %ss
	movl $stack_top, %esp

	movl $(boot_pagedir - 0xc0000000), %eax
	movl %eax, %cr3
	movl %cr4, %eax
	orl $CR4_PSE, %eax
	movl %eax, %cr4
	movl %cr0, %eax
	orl $(CR0_PG | CR0_WP), %eax
	movl %eax, %cr0

	lea high, %eax
	jmp *%eax

.include "arch/x86/gdt.s"
	
.section .text
high:	
	movl %ecx, %eax
	pushl $0
	popf
	pushl %eax		#multiboot magic
	pushl %ebx		#multiboot_info_t*
	.extern kmain
	call kmain

	cli
.1:
	hlt
	jmp .1
.end:
