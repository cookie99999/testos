#include <stdint.h>

#include "ports.h"
#include "vga.h"

/* VGA port IO wrappers */

static void vga_outb(uint8_t reg, uint8_t data) {
  outb(VGA_CTRL_REG, reg);
  outb(VGA_DATA_REG, data);
}

static void vga_outw(uint8_t reg, uint16_t data) {
  outb(VGA_CTRL_REG, reg);
  outb(VGA_DATA_REG, (uint8_t)((data >> 8) & 0x00ff));
  outb(VGA_CTRL_REG, reg + 1);
  outb(VGA_DATA_REG, (uint8_t)(data & 0x00ff));
}

static uint8_t vga_inb(uint8_t reg) {
  uint8_t result;
  outb(VGA_CTRL_REG, reg);
  result = inb(VGA_DATA_REG);
  return result;
}

static uint16_t vga_inw(uint8_t reg) {
  uint16_t result;
  outb(VGA_CTRL_REG, reg);
  result = inb(VGA_DATA_REG) << 8;
  outb(VGA_CTRL_REG, reg + 1);
  result |= inb(VGA_DATA_REG);
  return result;
}
  
void set_cursor_pos(uint16_t offs) {
  vga_outw(VGA_CURSOR_POS, offs / 2); //2 bytes per character
}

uint16_t get_cursor_pos() {
  return vga_inw(VGA_CURSOR_POS) * 2; //2 bytes per character
}
