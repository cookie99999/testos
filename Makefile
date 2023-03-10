HEADERS = $(wildcard *.h drivers/*.h arch/*/*.h)
SOURCE = $(wildcard *.c drivers/*.c arch/*/*.c)
OBJ = $(patsubst %.c,%.o,${SOURCE} arch/x86/isr_wrapper.o)

CC = i386-elf-gcc
CFLAGS = -std=c17 -g3 -Og -Wall -Wextra -Wpedantic -Wconversion -Wstrict-prototypes

testos.bin: mbr.bin kernel.bin
	cat $^ > $@
	qemu-img create -f raw hdd.img 20M
	dd if=testos.bin of=hdd.img bs=512 conv=notrunc

kernel.bin: kernel-entry.o ${OBJ}
	i386-elf-ld -o $@ -T linker.ld $^ --oformat binary

kernel.elf: kernel-entry.o ${OBJ}
	i386-elf-ld -o $@ -T linker.ld $^ --oformat elf32-i386

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.s
	nasm $< -f elf -o $@

%.bin: %.s
	nasm $< -f bin -o $@

debug: testos.bin kernel.elf
	qemu-system-i386 -s -S -no-reboot -drive format=raw,media=disk,file=hdd.img & gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

clean:
	$(RM) *.bin *.o *.dis *.elf *.img
	$(RM) drivers/*.o arch/*/*.o
