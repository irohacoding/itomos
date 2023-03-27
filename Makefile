### Makefile
# $@ = target file
# $< = first dependency
# $^ = all dependency
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: run

itomos.bin: boot/boot.bin kernel.bin
	cat $^ > itomos.bin

kernel.bin: boot/kernel-entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

run: itomos.bin
	qemu-system-i386 -fda itomos.bin -boot a

%.o: %.c ${HEADERS}
	gcc -m32 -fno-pie -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.o *.elf
	rm -rf kernel/*.o boot/*.o boot/*.bin drivers/*.o
