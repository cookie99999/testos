gdt_start:
	.quad 0x00		#null entry required

gdt_code:
	.word 0xffff		#length
	.word 0x0000		#base
	.byte 0x00		#base (middle bits)
	.byte 0b10011010	#flags
	.byte 0b11001111	#flags + length top bits
	.byte 0x00		#base top bits

gdt_data:
	.word 0xffff		#length
	.word 0x0000		#base
	.byte 0x00		#base middle bits
	.byte 0b10010010	#flags
	.byte 0b11001111	#flags + length top bits
	.byte 0x00		#base top bits

gdt_end:

gdt_descriptor:
	.word gdt_end - gdt_start - 1 #size
	.long gdt_start		   #address

	.set CODE_SEG, gdt_code - gdt_start
	.set DATA_SEG, gdt_data - gdt_start
