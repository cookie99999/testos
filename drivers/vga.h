#include <stdint.h>

#define VGA_CTRL_REG 0x3d4
#define VGA_DATA_REG 0x3d5
#define VGA_CURSOR_POS 0x0e

uint16_t get_cursor_pos(void);
void set_cursor_pos(uint16_t offs);
