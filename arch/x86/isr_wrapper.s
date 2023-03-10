	extern default_exception_handler
	extern default_irq_handler
	extern irq0_handler

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
	push esp		;pointer to the above data (intr_stack_t)

	cld			;sysv abi requires direction flag clear on func entry
	call default_exception_handler

	pop eax
	pop eax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8		;pop off error code and int num
	iret

irq_wrapper:
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10		;kernel data seg
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	push esp

	cld
	call default_irq_handler

	pop ebx			;why does it use ebx?
	pop ebx
	mov ds, bx
	mov es, bx
	mov fs, bx
	mov gs, bx
	popa
	add esp, 8
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
	push byte 0
	push byte 0
	jmp isr_wrapper

isr1:				;debug interrupt
	push byte 0
	push byte 1
	jmp isr_wrapper

isr2:				;nmi
	push byte 0
	push byte 2
	jmp isr_wrapper

isr3:				;breakpoint
	push byte 0
	push byte 3
	jmp isr_wrapper

isr4:				;overflow
	push byte 0
	push byte 4
	jmp isr_wrapper

isr5:				;bound range exceeded
	push byte 0
	push byte 5
	jmp isr_wrapper

isr6:				;invalid opcode
	push byte 0
	push byte 6
	jmp isr_wrapper

isr7:				;device not available
	push byte 0
	push byte 7
	jmp isr_wrapper
	
isr8:				;double fault	
	push byte 8
	jmp isr_wrapper

isr9:				;coprocessor segment overrun
	push byte 0
	push byte 9
	jmp isr_wrapper
	
isr10:				;invalid tss
	push byte 10
	jmp isr_wrapper

isr11:				;segment not present
	push byte 11
	jmp isr_wrapper

isr12:				;stack segment fault
	push byte 12
	jmp isr_wrapper

isr13:				;general protection fault
	push byte 13
	jmp isr_wrapper

isr14:				;page fault
	push byte 14
	jmp isr_wrapper

isr15:				;reserved
	push byte 0
	push byte 15
	jmp isr_wrapper

isr16:				;floating point exception
	push byte 0
	push byte 16
	jmp isr_wrapper

isr17:				;alignment check
	push byte 0
	push byte 17
	jmp isr_wrapper

isr18:				;machine check
	push byte 0
	push byte 18
	jmp isr_wrapper

isr19:				;reserved
	push byte 0
	push byte 19
	jmp isr_wrapper

isr20:				;reserved
	push byte 0
	push byte 20
	jmp isr_wrapper

isr21:				;reserved
	push byte 0
	push byte 21
	jmp isr_wrapper

isr22:				;reserved
	push byte 0
	push byte 22
	jmp isr_wrapper

isr23:				;reserved
	push byte 0
	push byte 23
	jmp isr_wrapper

isr24:				;reserved
	push byte 0
	push byte 24
	jmp isr_wrapper

isr25:				;reserved
	push byte 0
	push byte 25
	jmp isr_wrapper

isr26:				;reserved
	push byte 0
	push byte 26
	jmp isr_wrapper
isr27:				;reserved
	push byte 0
	push byte 27
	jmp isr_wrapper
isr28:				;reserved
	push byte 0
	push byte 28
	jmp isr_wrapper

isr29:				;reserved
	push byte 0
	push byte 29
	jmp isr_wrapper

isr30:				;reserved
	push byte 0
	push byte 30
	jmp isr_wrapper

isr31:				;reserved
	push byte 0
	push byte 31
	jmp isr_wrapper

	;; hardware irqs
	global irq0
	global irq1
	global irq2
	global irq3
	global irq4
	global irq5
	global irq6
	global irq7
	global irq8
	global irq9
	global irq10
	global irq11
	global irq12
	global irq13
	global irq14
	global irq15

irq0:
	pusha
	cld
	call irq0_handler
	popa
	iret

irq1:
	push byte 0
	push byte 33
	jmp irq_wrapper

irq2:
	push byte 0
	push byte 34
	jmp irq_wrapper

irq3:
	push byte 0
	push byte 35
	jmp irq_wrapper

irq4:
	push byte 0
	push byte 36
	jmp irq_wrapper

irq5:
	push byte 0
	push byte 37
	jmp irq_wrapper

irq6:
	push byte 0
	push byte 38
	jmp irq_wrapper

irq7:
	push byte 0
	push byte 39
	jmp irq_wrapper

irq8:
	push byte 0
	push byte 40
	jmp irq_wrapper

irq9:
	push byte 0
	push byte 41
	jmp irq_wrapper

irq10:
	push byte 0
	push byte 42
	jmp irq_wrapper

irq11:
	push byte 0
	push byte 43
	jmp irq_wrapper

irq12:
	push byte 0
	push byte 44
	jmp irq_wrapper

irq13:
	push byte 0
	push byte 45
	jmp irq_wrapper

irq14:
	push byte 0
	push byte 46
	jmp irq_wrapper

irq15:
	push byte 0
	push byte 47
	jmp irq_wrapper
