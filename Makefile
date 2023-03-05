HEADERS = $(wildcard *.h drivers/*.h)
OBJ = $(wildcard *.o drivers/*.o)

CC = i386-elf-gcc
CFLAGS = -std=c17 -g3 -O0 -Wall -Wextra -Wpedantic -Wconversion -Wstrict-prototypes
all: testos.bin

testos.bin: mbr.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel-entry.o ${OBJ}
	i386-elf-ld -o $@ -T linker.ld $^ --oformat binary

kernel.elf: kernel-entry.o ${OBJ}
	i386-elf-ld -o $@ -T linker.ld $^

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.s
	nasm $< -f elf -o $@

%.bin: %.s
	nasm $< -f bin -o $@

clean:
	$(RM) *.bin *.o *.dis *.elf
	$(RM) drivers/*.o
