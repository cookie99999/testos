#ifndef _INTERRUPTS_H
#define _INTERRUPTS_H 1

#include <stdint.h>

#define IDT_NUM_ENTRIES 256

#define IDT_ATTR_PRESENT 0x80
#define IDT_ATTR_DPL_0 0x00
#define IDT_ATTR_DPL_1 0x20
#define IDT_ATTR_DPL_2 0x40
#define IDT_ATTR_DPL_3 0x60
#define IDT_ATTR_INTR_GATE 0x0e
#define IDT_ATTR_TRAP_GATE 0x0f

typedef struct {
  uint16_t offs_0;
  uint16_t selector;
  uint8_t reserved;
  uint8_t attributes;
  uint16_t offs_1;
} __attribute__((packed)) idt_entry_t;

typedef struct {
  uint16_t size;
  uint32_t offs;
} __attribute__((packed)) idtr_t;

typedef struct {
  uint32_t ds, edi, esi, ebp, oldesp, ebx, edx, ecx, eax,
    num, error, eip, cs, eflags, esp, ss;
} intr_stack_t;

extern idt_entry_t idt[IDT_NUM_ENTRIES];
extern idtr_t idtr;

void set_idt_entry(int n, uint32_t handler);
void load_idtr(void);
void setup_idt(void);
void default_exception_handler(intr_stack_t* is);
void default_irq_handler(intr_stack_t* is);

extern void isr0(void);
extern void isr1(void);
extern void isr2(void);
extern void isr3(void);
extern void isr4(void);
extern void isr5(void);
extern void isr6(void);
extern void isr7(void);
extern void isr8(void);
extern void isr9(void);
extern void isr10(void);
extern void isr11(void);
extern void isr12(void);
extern void isr13(void);
extern void isr14(void);
extern void isr15(void);
extern void isr16(void);
extern void isr17(void);
extern void isr18(void);
extern void isr19(void);
extern void isr20(void);
extern void isr21(void);
extern void isr22(void);
extern void isr23(void);
extern void isr24(void);
extern void isr25(void);
extern void isr26(void);
extern void isr27(void);
extern void isr28(void);
extern void isr29(void);
extern void isr30(void);
extern void isr31(void);

extern void irq0(void);
extern void irq1(void);
extern void irq2(void);
extern void irq3(void);
extern void irq4(void);
extern void irq5(void);
extern void irq6(void);
extern void irq7(void);
extern void irq8(void);
extern void irq9(void);
extern void irq10(void);
extern void irq11(void);
extern void irq12(void);
extern void irq13(void);
extern void irq14(void);
extern void irq15(void);
#endif
