	.extern default_exception_handler
	.extern default_irq_handler
	.extern irq0_handler

isr_wrapper:
	/* pass state on stack for handler */
	pusha
	movw %ds, %ax
	pushl %eax
	movw $0x10, %ax		#kernel data seg
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	pushl %esp		#pointer to the above data (intr_stack_t)

	cld			#sysv abi requires direction flag clear on func entry
	call default_exception_handler

	popl %eax
	popl %eax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	popa
	addl $8, %esp		#pop off error code and int num
	iret

irq_wrapper:
	pusha
	movw %ds, %ax
	pushl %eax
	movw $0x10, %ax		#kernel data seg
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	pushl %esp

	cld
	call default_irq_handler

	popl %ebx			#why does it use ebx?
	popl %ebx
	movw %bx, %ds
	movw %bx, %es
	movw %bx, %fs
	movw %bx, %gs
	popa
	addl $8, %esp
	iret

	/* cpu exceptions */

	.global isr0
	.global isr1
	.global isr2
	.global isr3
	.global isr4
	.global isr5
	.global isr6
	.global isr7
	.global isr8
	.global isr9
	.global isr10
	.global isr11
	.global isr12
	.global isr13
	.global isr14
	.global isr15
	.global isr16
	.global isr17
	.global isr18
	.global isr19
	.global isr20
	.global isr21
	.global isr22
	.global isr23
	.global isr24
	.global isr25
	.global isr26
	.global isr27
	.global isr28
	.global isr29
	.global isr30
	.global isr31

isr0:				#division error
	push $0
	push $0
	jmp isr_wrapper

isr1:				#debug interrupt
	push $0
	push $1
	jmp isr_wrapper

isr2:				#nmi
	push $0
	push $2
	jmp isr_wrapper

isr3:				#breakpoint
	push $0
	push $3
	jmp isr_wrapper

isr4:				#overflow
	push $0
	push $4
	jmp isr_wrapper

isr5:				#bound range exceeded
	push $0
	push $5
	jmp isr_wrapper

isr6:				#invalid opcode
	push $0
	push $6
	jmp isr_wrapper

isr7:				#device not available
	push $0
	push $7
	jmp isr_wrapper
	
isr8:				#double fault	
	push $8
	jmp isr_wrapper

isr9:				#coprocessor segment overrun
	push $0
	push $9
	jmp isr_wrapper
	
isr10:				#invalid tss
	push $10
	jmp isr_wrapper

isr11:				#segment not present
	push $11
	jmp isr_wrapper

isr12:				#stack segment fault
	push $12
	jmp isr_wrapper

isr13:				#general protection fault
	push $13
	jmp isr_wrapper

isr14:				#page fault
	push $14
	jmp isr_wrapper

isr15:				#reserved
	push $0
	push $15
	jmp isr_wrapper

isr16:				#floating point exception
	push $0
	push $16
	jmp isr_wrapper

isr17:				#alignment check
	push $0
	push $17
	jmp isr_wrapper

isr18:				#machine check
	push $0
	push $18
	jmp isr_wrapper

isr19:				#reserved
	push $0
	push $19
	jmp isr_wrapper

isr20:				#reserved
	push $0
	push $20
	jmp isr_wrapper

isr21:				#reserved
	push $0
	push $21
	jmp isr_wrapper

isr22:				#reserved
	push $0
	push $22
	jmp isr_wrapper

isr23:				#reserved
	push $0
	push $23
	jmp isr_wrapper

isr24:				#reserved
	push $0
	push $24
	jmp isr_wrapper

isr25:				#reserved
	push $0
	push $25
	jmp isr_wrapper

isr26:				#reserved
	push $0
	push $26
	jmp isr_wrapper
isr27:				#reserved
	push $0
	push $27
	jmp isr_wrapper
isr28:				#reserved
	push $0
	push $28
	jmp isr_wrapper

isr29:				#reserved
	push $0
	push $29
	jmp isr_wrapper

isr30:				#reserved
	push $0
	push $30
	jmp isr_wrapper

isr31:				#reserved
	push $0
	push $31
	jmp isr_wrapper

	/* hardware irqs */
	.global irq0
	.global irq1
	.global irq2
	.global irq3
	.global irq4
	.global irq5
	.global irq6
	.global irq7
	.global irq8
	.global irq9
	.global irq10
	.global irq11
	.global irq12
	.global irq13
	.global irq14
	.global irq15

irq0:
	pusha
	cld
	call irq0_handler
	popa
	iret

irq1:
	push $0
	push $33
	jmp irq_wrapper

irq2:
	push $0
	push $34
	jmp irq_wrapper

irq3:
	push $0
	push $35
	jmp irq_wrapper

irq4:
	push $0
	push $36
	jmp irq_wrapper

irq5:
	push $0
	push $37
	jmp irq_wrapper

irq6:
	push $0
	push $38
	jmp irq_wrapper

irq7:
	push $0
	push $39
	jmp irq_wrapper

irq8:
	push $0
	push $40
	jmp irq_wrapper

irq9:
	push $0
	push $41
	jmp irq_wrapper

irq10:
	push $0
	push $42
	jmp irq_wrapper

irq11:
	push $0
	push $43
	jmp irq_wrapper

irq12:
	push $0
	push $44
	jmp irq_wrapper

irq13:
	push $0
	push $45
	jmp irq_wrapper

irq14:
	push $0
	push $46
	jmp irq_wrapper

irq15:
	push $0
	push $47
	jmp irq_wrapper
