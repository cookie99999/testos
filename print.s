	;; real mode printing functions
	
puts: 				;ds:si = string
	pusha
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	jz .end
	int 0x10
	jmp .loop
.end:
	popa
	ret

newline:
	pusha
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
	ret
	
print_hex: 			;al = hex byte
	pusha
	mov cl, 2
	mov bx, ax
	and al, 0xf0
	shr al, 4
.again:
	cmp al, 0x0a
	jl .skip
	add al, 65 - 0x0a
	jmp .skip2
.skip:
	add al, 48
.skip2:
	mov ah, 0x0e
	int 0x10

	dec cl
	jz .end
	mov ax, bx
	and al, 0x0f
	jmp .again
.end:
	popa
	ret
