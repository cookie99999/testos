all: testos.bin

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -T linker.ld $^ --oformat binary

kernel-entry.o: kernel-entry.s
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pie -c $< -o $@

mbr.bin: mbr.s disk.s print.s
	nasm $< -f bin -o $@

testos.bin: mbr.bin kernel.bin
	cat $^ > $@

clean:
	$(RM) *.bin *.o *.dis
