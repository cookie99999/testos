all: testos.bin

kernel.bin: kernel-entry.o kernel.o
	i386-elf-ld -o $@ -T linker.ld $^ --oformat binary

kernel-entry.o: kernel-entry.s
	nasm $< -f elf -o $@

kernel.o: kernel.c
	i386-elf-gcc -g -O0 -ffreestanding -c $< -o $@

mbr.bin: mbr.s disk.s print.s
	nasm $< -f bin -o $@

testos.bin: mbr.bin kernel.bin
	cat $^ > $@

debug:
	i386-elf-ld -o kernel.elf -T linker.ld kernel-entry.o kernel.o --oformat elf32-i386

clean:
	$(RM) *.bin *.o *.dis
