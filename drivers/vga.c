#include <stdint.h>

#include "ports.h"
#include "vga.h"

//register arrays public domain by Chris Giese
uint8_t g320x200x256[] = {
  //misc
  0x63,
  //seq
  0x03, 0x01, 0x0f, 0x00, 0x0e,
  //crtc
  0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0xbf, 0x1f,
  0x00, 0x41, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x9c, 0x0e, 0x8f, 0x28, 0x40, 0x96, 0xb9, 0xa3,
  0xff,
  //gc
  0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x05, 0x0f,
  0xff,
  //ac
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
  0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
  0x41, 0x00, 0x0f, 0x00, 0x00
};

uint8_t g80x25_text[] = {
  //misc
  0x67,
  //seq
  0x03, 0x00, 0x03, 0x00, 0x02,
  //crtc
  0x5f, 0x4f, 0x50, 0x82, 0x55, 0x81, 0xbf, 0x1f,
  0x00, 0x4f, 0x0d, 0x0e, 0x00, 0x00, 0x00, 0x50,
  0x9c, 0x0e, 0x8f, 0x28, 0x1f, 0x96, 0xb9, 0xa3,
  0xff,
  //gc
  0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x0e, 0x00,
  0xff,
  //ac
  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07,
  0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
  0x0c, 0x00, 0x0f, 0x08, 0x00
};

/* VGA port IO wrappers */

static void vga_outb(uint16_t index_reg, uint8_t reg, uint8_t data) {
  outb(index_reg, reg);
  outb(index_reg + 1, data);
}

static void vga_outw(uint16_t index_reg, uint8_t reg, uint16_t data) {
  outb(index_reg, reg);
  outb(index_reg + 1, (uint8_t)((data >> 8) & 0x00ff));
  outb(index_reg, reg + 1);
  outb(index_reg + 1, (uint8_t)(data & 0x00ff));
}

static uint8_t vga_inb(uint16_t index_reg, uint8_t reg) {
  uint8_t result;
  outb(index_reg, reg);
  result = inb(index_reg + 1);
  return result;
}

static uint16_t vga_inw(uint16_t index_reg, uint8_t reg) {
  uint16_t result;
  outb(index_reg, reg);
  result = inb(index_reg + 1) << 8;
  outb(index_reg, reg + 1);
  result |= inb(index_reg + 1);
  return result;
}

/* text mode functions */

static void set_cursor_offs(uint16_t offs) {
  offs %= VGA_MAX_ROWS * VGA_MAX_COLS;
  vga_outw(VGA_CRTC_INDEX, VGA_CRTC_CURSOR_POS, offs);
}

static void set_cursor_pos(int x, int y) {
  y %= VGA_MAX_ROWS;
  x %= VGA_MAX_COLS;
  set_cursor_offs((uint16_t)(y * VGA_MAX_ROWS + x));
}

static uint16_t get_cursor_pos(void) {
  return vga_inw(VGA_CRTC_INDEX, VGA_CRTC_CURSOR_POS);
}

static void scroll_screen_up(void) {
  uint8_t* screen = (uint8_t*)VGA_VRAM;
  uint8_t* next = screen + (VGA_MAX_COLS * 2);

  int n = ((VGA_MAX_ROWS - 1) * VGA_MAX_COLS) * 2;
  while (n--) {
    *screen++ = *next++;
  }

  for (int i = 0; i < VGA_MAX_COLS; i++) { //blank bottom row
    screen[i * 2] = ' ';
    screen[i * 2 + 1] = 0x0f;
  }
}

void clear_screen_text() {
  uint8_t* screen = (uint8_t*)VGA_VRAM;
  for (int i = 0; i < VGA_MAX_ROWS * VGA_MAX_COLS * 2; i += 2) {
    screen[i] = ' ';
    screen[i + 1] = 0x0f; //white on black
  }

  set_cursor_pos(0, 0);
}

static void kprint_char(char c, int x, int y, char attr) {
  char* screen = (char*)VGA_VRAM;
  uint16_t offs;

  if (x == -1 || y == -1) {
    offs = get_cursor_pos();
  } else {
    offs = (uint16_t)(y * VGA_MAX_COLS + x);
  }

  if (c == '\n') {
    offs = (uint16_t)((y + 1) * VGA_MAX_COLS);
  } else {
    screen[offs * 2] = c;
    screen[offs * 2 + 1] = attr ? attr : 0x0f; //white on black default
    offs += 2;
  }
  set_cursor_offs(offs);
}

void kprint_at(char* string, int x, int y) {
  uint16_t offs;

  if (x == -1 || y == -1) {
    offs = get_cursor_pos();
    y = offs / VGA_MAX_COLS;
    x = offs - (y * VGA_MAX_COLS);
  }

  int i = 0;
  while (string[i] != '\0') {
    kprint_char(string[i], x, y, 0);
    if (string[i] == '\n') {
      x = 0;
      y++;
    } else {
      x++;
    }
    
    if (x >= VGA_MAX_COLS) {
      x = 0;
      y++;
    }
    
    if (y >= VGA_MAX_ROWS) {
      y--;
      scroll_screen_up();
    }

    i++;
  }
}

void kprint(char* string) {
  kprint_at(string, -1, -1);
}

/* modesetting functions */

void vga_save_regs(uint8_t* regbuf) {
  *regbuf++ = inb(VGA_MISC_READ);

  for (uint8_t i = 0; i < VGA_NUM_SEQ; i++) {
    *regbuf++ = vga_inb(VGA_SEQ_INDEX, i);
  }

  for (uint8_t i = 0; i < VGA_NUM_CRTC; i++) {
    *regbuf++ = vga_inb(VGA_CRTC_INDEX, i);
  }

  for (uint8_t i = 0; i < VGA_NUM_GC; i++) {
    *regbuf++ = vga_inb(VGA_GC_INDEX, i);
  }

  for (uint8_t i = 0; i < VGA_NUM_AC; i++) {
    /* reading attribute controller is different
       we must read from input status #1 first to reset a flipflop
       todo: interrupt/multitask safety in here for flipflop state
       todo: procedure for undocumented flipflop status bit
    */
    inb(VGA_INSTAT_READ);
    *regbuf++ = vga_inb(VGA_AC_INDEX, i);
  }

  /* giese code says this is required, find out why */
  inb(VGA_INSTAT_READ);
  outb(VGA_AC_WRITE, 0x20);
}

void vga_write_regs(uint8_t* regbuf) {
  outb(VGA_MISC_WRITE, *regbuf++);

  for (uint8_t i = 0; i < VGA_NUM_SEQ; i++) {
    vga_outb(VGA_SEQ_INDEX, i, *regbuf++);
  }

  /* crtc registers must be unlocked
     don't know why giese does the 0x03 bit 7 since freevga says its ega compat only */
  vga_outb(VGA_CRTC_INDEX, 0x03, vga_inb(VGA_CRTC_INDEX, 0x03) | 0x80);
  vga_outb(VGA_CRTC_INDEX, 0x11, vga_inb(VGA_CRTC_INDEX, 0x11) & (uint8_t)~0x80);
  /* ensure they are still unlocked in the written values */
  regbuf[0x03] |= 0x80;
  regbuf[0x11] &= (uint8_t)~0x80;

  for (uint8_t i = 0; i < VGA_NUM_CRTC; i++) {
    vga_outb(VGA_CRTC_INDEX, i, *regbuf++);
  }

  for (uint8_t i = 0; i < VGA_NUM_GC; i++) {
    vga_outb(VGA_GC_INDEX, i, *regbuf++);
  }

  /* ac writing is same as reading above */
  for (uint8_t i = 0; i < VGA_NUM_AC; i++) {
    inb(VGA_INSTAT_READ);
    vga_outb(VGA_AC_INDEX, i, *regbuf++);
  }

  /* same as read func */
  inb(VGA_INSTAT_READ);
  outb(VGA_AC_WRITE, 0x20);
}
}
