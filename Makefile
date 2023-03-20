### Makefile
# $@ = target file
# $< = first dependency
# $^ = all dependency

all: run

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel-entry.o: kernel-entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

boot.bin: boot.asm
	nasm $< -f bin -o $@

itomos.bin: boot.bin kernel.bin
	cat $^ > $@

run: itomos.bin
	qemu-system-i386 -fda $<

clean:
	$(RM) *.bin *.o *.dis
