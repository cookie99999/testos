HEADERS := $(wildcard *.h drivers/*.h arch/*/*.h)
SOURCE := $(wildcard *.c drivers/*.c arch/*/*.c)
OBJ := $(patsubst %.c,%.o,${SOURCE} arch/x86/isr_wrapper.o)

CC := i386-elf-gcc
AS := i386-elf-as
CFLAGS := -ffreestanding -std=c17 -g3 -Og -Wall -Wextra -Wpedantic -Wconversion -Wstrict-prototypes
LDFLAGS := -ffreestanding -Og -g3 -nostdlib

testos.bin: boot.o ${OBJ}
	${CC} -T linker.ld -o $@ ${LDFLAGS} $? -lgcc
	@mkdir -p iso/boot/grub
	@cp grub.cfg iso/boot/grub
	@cp $@ iso/boot
	@grub-mkrescue -o testos.iso iso

%.o: %.c ${HEADERS} Makefile
	${CC} ${CFLAGS} -c $< -o $@

boot.o: arch/x86/boot.s
	${AS} $< -o $@
%.o: %.s
	${AS} $< -o $@

run: testos.bin
	@qemu-system-i386 -no-reboot -m 32 -cdrom testos.iso

debug: testos.bin
	@qemu-system-i386 -s -S -no-reboot -m 32 -cdrom testos.iso & gdb -ex "target remote localhost:1234" -ex "symbol-file testos.bin"

clean:
	-@rm -f *.bin *.o *.dis *.elf *.iso
	-@rm -f drivers/*.o arch/*/*.o
	-@rm -rf iso/

.PHONY: all clean run dist
