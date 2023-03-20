#include "drivers/vga.h"
#include "arch/x86/interrupts.h"
#include "arch/x86/pic.h"
#include "arch/x86/pit.h"
#include "arch/x86/multiboot.h"

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

void kitoa_hex(uint64_t n, char* s) {
  int j = 0;
  s[j++] = '0';
  s[j++] = 'x';
  for (int i = 60; i >=0; i -= 4) {
    int nyb = ((n >> i) & 0xf);
    if (nyb  > 9) {
      s[j] = (char)(nyb - 10) + 'a';
    } else {
      s[j] = (char)nyb + '0';
    }
    j++;
  }
  s[j] = '\0';
}

void parse_mmap(multiboot_info_t* mbd) {
  int num_maps = mbd->mmap_length / sizeof(multiboot_memory_map_t);
  kprint("maps: ");
  char s[6];
  kitoa(num_maps, s);
  kprint(s);
  kprint("\n");

  int i = 0;
  while (i < mbd->mmap_length) {
    multiboot_memory_map_t* mmap = (multiboot_memory_map_t*)(mbd->mmap_addr + i);
    kprint("type: ");
    kitoa(mmap->type, s);
    kprint(s);
    kprint("   ");

    kprint("start: ");
    char x[11];
    kitoa_hex(mmap->addr, x);
    kprint(x);
    kprint("   ");

    kprint("length: ");
    kitoa_hex(mmap->len, x);
    kprint(x);
    kprint("\n");
    i += mmap->size + 4; //size leaves out itself
  }
}

void kmain(multiboot_info_t* mbd, uint32_t magic) {
  if (magic != MULTIBOOT_BOOTLOADER_MAGIC) {
    kprint("PANIC: wrong magic number\n");
    char s[6];
    kitoa(magic, s);
    kprint(s);
    __asm__("cli");
    __asm__("hlt");
  }
  
  clear_screen_text();
  if (mbd->flags & 1) {
    kprint("mem_lower and mem_upper valid\n");
    kprint("mem_lower: ");
    char s[6];
    kitoa(mbd->mem_lower, s);
    kprint(s);
    kprint("\n");
    kprint("mem_upper: ");
    kitoa(mbd->mem_upper, s);
    kprint(s);
    kprint("\n");
  } else {
    kprint("mem_lower and mem_upper not valid\n");
  }

  if (mbd->flags & (1 << 6)) {
    kprint("mmap fields valid\n");
    parse_mmap(mbd);
  } else {
    kprint("mmap fields invalid\n");
  }

  setup_idt();
  pic_primary_set_masks(0xf8);
  pic_secondary_set_masks(0xff);

  pit_set_mode(PIT_CMD_CHAN_0 | PIT_CMD_ACC_MODE_LOHI | PIT_CMD_OPMODE_2);
  pit_set_reload(0, 0);
  __asm__("sti");

  while (1)
    ;
}
