#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VGA_VRAM 0xb8000
#define VGA_MAX_COLS 80
#define VGA_MAX_ROWS 25

#define VGA_AC_INDEX 0x3c0
#define VGA_AC_DATA 0x3c1
#define VGA_AC_WRITE 0x3c0

#define VGA_MISC_WRITE 0x3c2
#define VGA_MISC_READ 0x3cc

#define VGA_SEQ_INDEX 0x3c4
#define VGA_SEQ_DATA 0x3c5

#define VGA_DAC_READ_INDEX 0x3c7
#define VGA_DAC_WRITE_INDEX 0x3c8
#define VGA_DAC_DATA 0x3c9

#define VGA_GC_INDEX 0x3ce
#define VGA_GC_DATA 0x3cf

#define VGA_CRTC_INDEX 0x3d4
#define VGA_CRTC_DATA 0x3d5
#define VGA_CRTC_CURSOR_POS 0x0e

#define VGA_INSTAT_READ 0x3da

#define VGA_NUM_SEQ 5
#define VGA_NUM_CRTC 25
#define VGA_NUM_GC 9
#define VGA_NUM_AC 21
#define VGA_NUM_TOTAL (1 + VGA_NUM_SEQ + VGA_NUM_CRTC + VGA_NUM_GC + VGA_NUM_AC)

extern uint8_t g320x200x256[VGA_NUM_TOTAL];
extern uint8_t g80x25_text[VGA_NUM_TOTAL];

void clear_screen_text(void);
void kprint_at(char* string, int x, int y);
void kprint(char* string);
void kitoa(int n, char* s);

void vga_save_regs(uint8_t* regbuf);
void vga_write_regs(uint8_t* regbuf);

void set_pixel(int x, int y, uint8_t color);
void clear_screen_13(void);
#endif
