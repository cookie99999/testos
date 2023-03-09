#include <stdint.h>

#include "pic.h"

void remap_pics(uint8_t primary_offs, uint8_t secondary_offs) {
  uint8_t m1, m2; //mask backup
  m1 = inb(PIC_PRIMARY_DATA);
  m2 = inb(PIC_SECONDARY_DATA);

  outb(PIC_PRIMARY_CMD, PIC_ICW1_INIT | PIC_ICW1_ICW4);
  outb(PIC_SECONDARY_CMD, PIC_ICW1_INIT | PIC_ICW1_ICW4);
  outb(PIC_PRIMARY_DATA, primary_offs);
  outb(PIC_SECONDARY_DATA, secondary_offs);
  outb(PIC_PRIMARY_DATA, 0x04); //secondary pic present
  outb(PIC_SECONDARY_DATA, 0x02); //cascade id
  outb(PIC_PRIMARY_DATA, PIC_ICW4_8086);
  outb(PIC_SECONDARY_DATA, PIC_ICW4_8086);

  //restore masks
  outb(PIC_PRIMARY_DATA, m1);
  outb(PIC_SECONDARY_DATA, m2);
}

void disable_pics() {
  outb(PIC_PRIMARY_DATA, 0xff);
  outb(PIC_SECONDARY_DATA, 0xff);
}

void send_eoi(int num) {
  if (num >= 0x28)
    outb(PIC_SECONDARY_CMD, PIC_EOI);
  outb(PIC_PRIMARY_CMD, PIC_EOI);
}

void pic_set_mask(uint8_t irq) {
  uint16_t port;
  uint8_t mask;

  if (irq < 8) {
    port = PIC_PRIMARY_DATA;
  } else {
    port = PIC_SECONDARY_DATA;
    irq -= 8;
  }
  mask = inb(port) | (1 << irq);
  outb(port, mask);
}

void pic_clear_mask(uint8_t irq) {
  uint16_t port;
  uint8_t mask;

  if (irq < 8) {
    port = PIC_PRIMARY_DATA;
  } else {
    port = PIC_SECONDARY_DATA;
    irq -= 8;
  }

  mask = inb(port) & (uint8_t)~(1 << irq);
  outb(port, mask);
}
