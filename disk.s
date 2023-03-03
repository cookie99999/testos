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
	call print_hex
	call newline

	mov ah, 0x42
	int 0x13
	jc disk_error

	popa
	ret

disk_error:
	push si
	mov si, disk_err_str
	call puts
	mov al, ah
	call print_hex
	call newline

	mov si, read_str
	call puts
	pop si
	mov word cx, [ds:si + 2]
	mov al, ch
	call print_hex
	mov al, cl
	call print_hex
	call newline

	mov al, 'X'
	int 0x10
	jmp $

disk_err_str:	db "Disk error: ",0
read_str:	db "Sectors read: ",0
