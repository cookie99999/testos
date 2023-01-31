all: run

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -T linker.ld $^ --oformat binary

kernel-entry.o: kernel-entry.s
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pie -c $< -o $@

mbr.bin: mbr.s
	nasm $< -f bin -o $@

#kernel-fixed.bin: kernel.bin
#	objcopy -O binary -j .text $< $@

testos.bin: mbr.bin kernel.bin
	cat $^ > $@

run: testos.bin
	dd status=progress if=$< of=/dev/fd0 bs=512

clean:
	$(RM) *.bin *.o *.dis
