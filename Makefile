HEADERS = $(wildcard *.h drivers/*.h)
SOURCE = $(wildcard *.c drivers/*.c)
OBJ = $(patsubst %.c,%.o,${SOURCE})

CC = i386-elf-gcc
CFLAGS = -std=c17 -g3 -Og -Wall -Wextra -Wpedantic -Wconversion -Wstrict-prototypes

testos.bin: mbr.bin kernel.bin
	cat $^ > $@

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
	qemu-system-i386 -s -S -no-reboot -drive format=raw,media=disk,file=testos.bin & gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

debug:
	i386-elf-ld -o kernel.elf -T linker.ld kernel-entry.o kernel.o --oformat elf32-i386

clean:
	$(RM) *.bin *.o *.dis *.elf
	$(RM) drivers/*.o
