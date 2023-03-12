	bits 16
	dap equ 0x600
	BOOT_DRIVE equ 0x800
	fat_offset equ 0x802
	data_offset equ 0x804
	fat_buffer equ 0x900
	dir_buffer equ 0xa00
	stage2_entry equ 0x8000

	org 0x7c5a
	
	sectors_per_cluster equ 0x7c0d
	reserved_sectors equ 0x7c0e
	num_fats equ 0x7c10
	sectors_per_fat equ 0x7c24
	root_dir_start equ 0x7c2c	;cluster number of root directory
start:
	cli
	cld
	jmp 0x0000:.fix_cs
.fix_cs:
	xor eax, eax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00
	mov bp, sp
	sti
	mov ebx, eax
	
	mov [BOOT_DRIVE], dl

	mov eax, [sectors_per_fat]
	mul byte [num_fats]
	mov bx, word [reserved_sectors]
	add eax, ebx
	mov dword [data_offset], eax

	mov [dap], byte 0x10	;packet size
	mov [dap+1], byte 0	;reserved
	mov ax, 2 ;todo: assuming stage2 will be found within first 2 sectors
	mov [dap+2], ax		;probably fine for a small partition though
	xor eax, eax
	mov ax, fat_buffer
	mov [dap+4], eax	;transfer buffer
	mov ax, word [reserved_sectors]
	mov [fat_offset], ax
	mov [dap+8], eax	;lower lba
	mov [dap+12], dword 0	;upper lba

	mov si, dap
	mov ah, 0x42
	int 0x13		;beginning of fat loaded to memory
	jc error

	xor eax, eax
	mov eax, dword [root_dir_start]
	sub eax, 2		;2 reserved clusters in fat
	mul byte [sectors_per_cluster]
	jc error
	add eax, dword [data_offset] ;eax now has lba of given cluster

	

error:
	mov ah, 0x0e
	mov al, 'X'
	int 0x10
	cli
	hlt
