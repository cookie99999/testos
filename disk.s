disk_load:
	pusha
	push dx

	mov al, dl
	mov ah, 0x0e
	mov bh, 0x00
	int 0x10
	
	mov ah, 0x02		;read mode
	mov al, dh		;num sectors
	mov cl, 0x02		;start sector (sec 1 is mbr)
	mov ch, 0x00		;cyl
	mov dh, 0x00		;head

	int 0x13
	jc disk_error

	pop dx
	cmp al, dh
	jne sectors_error

	popa
	ret

disk_error:
	mov al, ah
	jmp loop

sectors_error:
	mov al, 'S'
	jmp loop

loop:
	mov ah, 0x0e
	mov bh, 0x00
	int 0x10
	mov al, 'X'
	int 0x10
	jmp $
