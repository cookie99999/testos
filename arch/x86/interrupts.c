#include "interrupts.h"
#include "../../drivers/vga.h"
#include "pic.h"

idt_entry_t idt[IDT_NUM_ENTRIES];
idtr_t idtr;

void set_idt_entry(int n, uint32_t handler) {
  idt[n].offs_0 = (uint16_t)(handler & 0x0000ffff);
  idt[n].selector = 0x08; //kernel code segment selector
  idt[n].reserved = 0;
  idt[n].attributes = IDT_ATTR_INTR_GATE | IDT_ATTR_PRESENT;
  idt[n].offs_1 = (uint16_t)((handler & 0xffff0000) >> 16);
}

void load_idtr() {
  idtr.offs = (uint32_t) &idt;
  idtr.size = IDT_NUM_ENTRIES * sizeof(idt_entry_t) - 1;
  __asm__ volatile("lidt (%0)" : : "r" (&idtr));
}

void setup_idt() {
  set_idt_entry(0, (uint32_t)isr0);
  set_idt_entry(1, (uint32_t)isr1);
  set_idt_entry(2, (uint32_t)isr2);
  set_idt_entry(3, (uint32_t)isr3);
  set_idt_entry(4, (uint32_t)isr4);
  set_idt_entry(5, (uint32_t)isr5);
  set_idt_entry(6, (uint32_t)isr6);
  set_idt_entry(7, (uint32_t)isr7);
  set_idt_entry(8, (uint32_t)isr8);
  set_idt_entry(9, (uint32_t)isr9);
  set_idt_entry(10, (uint32_t)isr10);
  set_idt_entry(11, (uint32_t)isr11);
  set_idt_entry(12, (uint32_t)isr12);
  set_idt_entry(13, (uint32_t)isr13);
  set_idt_entry(14, (uint32_t)isr14);
  set_idt_entry(15, (uint32_t)isr15);
  set_idt_entry(16, (uint32_t)isr16);
  set_idt_entry(17, (uint32_t)isr17);
  set_idt_entry(18, (uint32_t)isr18);
  set_idt_entry(19, (uint32_t)isr19);
  set_idt_entry(20, (uint32_t)isr20);
  set_idt_entry(21, (uint32_t)isr21);
  set_idt_entry(22, (uint32_t)isr22);
  set_idt_entry(23, (uint32_t)isr23);
  set_idt_entry(24, (uint32_t)isr24);
  set_idt_entry(25, (uint32_t)isr25);
  set_idt_entry(26, (uint32_t)isr26);
  set_idt_entry(27, (uint32_t)isr27);
  set_idt_entry(28, (uint32_t)isr28);
  set_idt_entry(29, (uint32_t)isr29);
  set_idt_entry(30, (uint32_t)isr30);
  set_idt_entry(31, (uint32_t)isr31);

  remap_pics(0x20, 0x28);

  set_idt_entry(32, (uint32_t)irq0);
  set_idt_entry(33, (uint32_t)irq1);
  set_idt_entry(34, (uint32_t)irq2);
  set_idt_entry(35, (uint32_t)irq3);
  set_idt_entry(36, (uint32_t)irq4);
  set_idt_entry(37, (uint32_t)irq5);
  set_idt_entry(38, (uint32_t)irq6);
  set_idt_entry(39, (uint32_t)irq7);
  set_idt_entry(40, (uint32_t)irq8);
  set_idt_entry(41, (uint32_t)irq9);
  set_idt_entry(42, (uint32_t)irq10);
  set_idt_entry(43, (uint32_t)irq11);
  set_idt_entry(44, (uint32_t)irq12);
  set_idt_entry(45, (uint32_t)irq13);
  set_idt_entry(46, (uint32_t)irq14);
  set_idt_entry(47, (uint32_t)irq15);

  load_idtr();
}

/* x86 exception isrs */
void default_exception_handler(intr_stack_t* is) {
  kprint("interrupt received: ");
  char s[3];
  kitoa(is->num, s);
  kprint(s);
  kprint("\n");
}

/* irq0-15 */
void default_irq_handler(intr_stack_t* is) {
  kprint("IRQ received: ");
  char s[3];
  kitoa(is->num - 0x20, s);
  kprint(s);
  kprint("\n");
  send_eoi(is->num);
}
