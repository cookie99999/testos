disk_load:
	;; dl -> disk to load
	;; ds:si -> ptr to disk address packet

	;; disk address packet:
	;; byte: packet size
	;; byte: always 0
	;; word: num sectors
	;; dword: buf pointer (seg:offs little endian)
	;; dword: lower dword of start lba
	;; dword: upper word of start lba

	pusha

	mov al, dl
	mov ah, 0x0e
	mov bh, 0x00
	int 0x10 		;todo: hex print function

	mov ah, 0x42
	int 0x13
	jc disk_error

	popa
	ret

disk_error:
	mov al, ah
	mov ah, 0x0e
	mov bh, 0x00
	int 0x10

	mov word cx, [ds:si + 2]

	mov al, 'X'
	int 0x10
	jmp $
