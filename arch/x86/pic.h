#ifndef _PIC_H
#define _PIC_H 1

#define PIC_PRIMARY_CMD 0x20
#define PIC_PRIMARY_DATA 0x21
#define PIC_SECONDARY_CMD 0xa0
#define PIC_SECONDARY_DATA 0xa1

#define PIC_EOI 0x20 //end of interrupt

#define PIC_ICW1_ICW4 0x01
#define PIC_ICW1_SINGLE 0x02
#define PIC_ICW1_ADDR_INTERVAL 0x04
#define PIC_ICW1_LEVEL_TRIG 0x08
#define PIC_ICW1_INIT 0x10 //required to be set

#define PIC_ICW4_8086 0x01
#define PIC_ICW4_AUTO_EOI 0x02
#define PIC_ICW4_BUF_SECONDARY 0x08
#define PIC_ICW4_BUF_PRIMARY 0x0c
#define PIC_ICW4_FULLY_NESTED 0x10

void remap_pics(uint8_t primary_offs, uint8_t secondary_offs);
void disable_pics(void);
void send_eoi(int n);
void pic_set_mask(uint8_t irq);
void pic_clear_mask(uint8_t irq);
void pic_primary_set_masks(uint8_t m);
void pic_secondary_set_masks(uint8_t m);
#endif
