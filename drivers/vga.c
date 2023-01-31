#include "vga.h"

unsigned char port_byte_in(unsigned short port) {
  unsigned char result;
  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
  return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
  __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

void set_cursor(int offs) {
  offs /= 2;
  port_byte_out(VGA_CTRL_REG, VGA_OFFS_HIGH);
  port_byte_out(VGA_DATA_REG, (unsigned char) (offs >> 8));
  port_byte_out(VGA_CTRL_REG, VGA_OFFS_LOW);
  port_byte_out(VGA_DATA_REG, (unsigned char) (offs & 0xff));
}

int get_cursor() {
  port_byte_out(VGA_CTRL_REG, VGA_OFFS_HIGH);
  int offs = port_byte_in(VGA_DATA_REG) << 8;
  port_byte_out(VGA_CTRL_REG, VGA_OFFS_LOW);
  offs += port_byte_in(VGA_DATA_REG);
  return offs * 2;
}
