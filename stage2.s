	org 0x8000
	bits 16

	mov ah, 0x0e
	mov al, '2'
	int 0x10
	cli
	hlt
