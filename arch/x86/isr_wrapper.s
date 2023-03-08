	extern default_exception_handler

isr_wrapper:
	;; pass state on stack for handler
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10		;kernel data seg
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	call default_exception_handler

	pop eax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8		;pop off error code and int num
	sti
	iret

	;; cpu exceptions

	global isr0
	global isr1
	global isr2
	global isr3
	global isr4
	global isr5
	global isr6
	global isr7
	global isr8
	global isr9
	global isr10
	global isr11
	global isr12
	global isr13
	global isr14
	global isr15
	global isr16
	global isr17
	global isr18
	global isr19
	global isr20
	global isr21
	global isr22
	global isr23
	global isr24
	global isr25
	global isr26
	global isr27
	global isr28
	global isr29
	global isr30
	global isr31

isr0:				;division error
	cli
	push byte 0
	push byte 0
	jmp isr_wrapper

isr1:				;debug interrupt
	cli
	push byte 0
	push byte 1
	jmp isr_wrapper

isr2:				;nmi
	cli
	push byte 0
	push byte 2
	jmp isr_wrapper

isr3:				;breakpoint
	cli
	push byte 0
	push byte 3
	jmp isr_wrapper

isr4:				;overflow
	cli
	push byte 0
	push byte 4
	jmp isr_wrapper

isr5:				;bound range exceeded
	cli
	push byte 0
	push byte 5
	jmp isr_wrapper

isr6:				;invalid opcode
	cli
	push byte 0
	push byte 6
	jmp isr_wrapper

isr7:				;device not available
	cli
	push byte 0
	push byte 7
	jmp isr_wrapper
	
isr8:				;double fault
	cli	
	push byte 8
	jmp isr_wrapper

isr9:				;coprocessor segment overrun
	cli
	push byte 0
	push byte 9
	jmp isr_wrapper
	
isr10:				;invalid tss
	cli
	push byte 10
	jmp isr_wrapper

isr11:				;segment not present
	cli
	push byte 11
	jmp isr_wrapper

isr12:				;stack segment fault
	cli
	push byte 12
	jmp isr_wrapper

isr13:				;general protection fault
	cli
	push byte 13
	jmp isr_wrapper

isr14:				;page fault
	cli
	push byte 14
	jmp isr_wrapper

isr15:				;reserved
	cli
	push byte 0
	push byte 15
	jmp isr_wrapper

isr16:				;floating point exception
	cli
	push byte 0
	push byte 16
	jmp isr_wrapper

isr17:				;alignment check
	cli
	push byte 0
	push byte 17
	jmp isr_wrapper

isr18:				;machine check
	cli
	push byte 0
	push byte 18
	jmp isr_wrapper

isr19:				;reserved
	cli
	push byte 0
	push byte 19
	jmp isr_wrapper

isr20:				;reserved
	cli
	push byte 0
	push byte 20
	jmp isr_wrapper

isr21:				;reserved
	cli
	push byte 0
	push byte 21
	jmp isr_wrapper

isr22:				;reserved
	cli
	push byte 0
	push byte 22
	jmp isr_wrapper

isr23:				;reserved
	cli
	push byte 0
	push byte 23
	jmp isr_wrapper

isr24:				;reserved
	cli
	push byte 0
	push byte 24
	jmp isr_wrapper

isr25:				;reserved
	cli
	push byte 0
	push byte 25
	jmp isr_wrapper

isr26:				;reserved
	cli
	push byte 0
	push byte 26
	jmp isr_wrapper
isr27:				;reserved
	cli
	push byte 0
	push byte 27
	jmp isr_wrapper
isr28:				;reserved
	cli
	push byte 0
	push byte 28
	jmp isr_wrapper

isr29:				;reserved
	cli
	push byte 0
	push byte 29
	jmp isr_wrapper

isr30:				;reserved
	cli
	push byte 0
	push byte 30
	jmp isr_wrapper

isr31:				;reserved
	cli
	push byte 0
	push byte 31
	jmp isr_wrapper
