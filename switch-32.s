	bits 16
switch_32:
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or al, 1		;protected mode enable
	mov cr0, eax
	jmp CODE_SEG:init_32

	bits 32
init_32:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	call BEGIN_32BIT
