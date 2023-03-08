gdt_start:
	dq 0x00			;null entry required

gdt_code:
	dw 0xffff		;length
	dw 0x0000		;base
	db 0x00			;base (middle bits)
	db 10011010b		;flags
	db 11001111b		;flags + length top bits
	db 0x00			;base top bits

gdt_data:
	dw 0xffff		;length
	dw 0x0000		;base
	db 0x00			;base middle bits
	db 10010010b		;flags
	db 11001111b		;flags + length top bits
	db 0x00			;base top bits

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ;size
	dd gdt_start		   ;address

	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start
