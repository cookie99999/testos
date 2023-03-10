#include <stdint.h>

#include "pit.h"
#include "ports.h"
#include "../../drivers/vga.h"

uint8_t pit_read_status(int channel) {
  switch (channel) {
  case 0:
    outb(PIT_COMMAND, PIT_CMD_READ_BACK | PIT_READ_BACK_CHAN_0);
    return inb(PIT_CHAN_0_DATA);
    break;
  case 1:
    outb(PIT_COMMAND, PIT_CMD_READ_BACK | PIT_READ_BACK_CHAN_1);
    return inb(PIT_CHAN_1_DATA);
    break;
  case 2:
    outb(PIT_COMMAND, PIT_CMD_READ_BACK | PIT_READ_BACK_CHAN_2);
    return inb(PIT_CHAN_2_DATA);
    break;
  default:
    kprint("<ERROR> invalid channel sent to pit_read_status");
    __asm__("cli");
    __asm__("hlt");
    return 0;
    break;
  }
}

void pit_set_mode(uint8_t mode) {
  outb(PIT_COMMAND, mode);
}

uint16_t pit_read_count(int channel) {
  //todo: check input value, make sure access mode is correct
  __asm__("cli");
  outb(PIT_COMMAND, (uint8_t)((channel << 7) & 0xc0));
  return (inb(PIT_CHAN_0_DATA + channel) & 0x00ff) | (inb(PIT_CHAN_0_DATA + channel) << 8);
}

void pit_set_reload(int channel, uint16_t c) {
  __asm__("cli");
  outb(PIT_CHAN_0_DATA + channel, (uint8_t)(c & 0x00ff));
  outb(PIT_CHAN_0_DATA + channel, (uint8_t)((c >> 8) & 0x0ff));
}
