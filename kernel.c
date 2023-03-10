#include "drivers/vga.h"
#include "arch/x86/interrupts.h"
#include "arch/x86/pic.h"
#include "arch/x86/pit.h"

void draw_mandel(int w, int h, int iter_max, double zoom, double fx, double fy) {
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      double cx, cy;
      cx = (x - (w / 2)) / zoom;
      cx -= fx;
      cy = (y - (h / 2)) / zoom;
      cy -= fy;
      
      int i;
      double zx, zy, zx2, zy2, ztmp;
      zx = zy = 0;
      for(i = 1; i <= iter_max; i++) {
	zx2 = zx * zx;
	zy2 = zy * zy;
	ztmp = zx2 - zy2 + cx;
	zy = 2 * zx * zy + cy;
	zx = ztmp;

	if (zx2 + zy2 > 4) {
	  set_pixel(x, y, (uint8_t)(i % 256));
	  break;
	}
      }
      if (i > iter_max)
	set_pixel(x, y, 0);
    }
  }
}

void kmain(void) {
  clear_screen_text();
  kprint("printing text");
  kprint_at("like a boss\n", 77, 12);
  kprint_at("second row", 0, 1);
  kprint_at("third row", 0, 2);
  kprint_at("fourth row", 0, 3);

  setup_idt();
  __asm__ volatile("int $3");
  __asm__ volatile("int $16");
  pic_primary_set_masks(0xf8);
  pic_secondary_set_masks(0xff);

  pit_set_mode(PIT_CMD_CHAN_0 | PIT_CMD_ACC_MODE_LOHI | PIT_CMD_OPMODE_2);
  pit_set_reload(0, 0);
  __asm__("sti");

  while (1)
    ;
}
