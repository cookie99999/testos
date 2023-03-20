ENTRY(_start)

SECTIONS {
	 . = 1M;
	 _kernel_start = .;

	 .multiboot.data : {
	     *(.multiboot.data)
	 }

	 .multiboot.text : {
	     *(.multiboot.text)
	 }

	 . += 0xc0000000;
	 .text ALIGN(4K) : AT (ADDR (.text) - 0xc0000000) {
	       *(.text)
	 }

	 .rodata ALIGN(4K) : AT (ADDR (.rodata) - 0xc0000000) {
		*(.rodata)
	 }

	 .data ALIGN(4K) : AT (ADDR (.data) - 0xc0000000) {
	       *(.data)
	 }

	 .bss ALIGN(4K) : AT (ADDR (.bss) - 0xc0000000) {
	      *(COMMON)
	      *(.bss)
	      *(.early_stack)
	 }

	 _kernel_end = .;
}
