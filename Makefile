### Makefile
# $@ = target file
# $< = first dependency
# $^ = all dependency
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h)
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o}

all: run

itomos.bin: boot/boot.bin kernel.bin
	cat $^ > $@

kernel.bin: boot/kernel-entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

run: itomos.bin
	qemu-system-i386 -fda $< -boot a

echo: itomos.bin
	xxd $<

kernel.elf: boot/kernel-entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

debug: itomos.bin kernel.elf
	qemu-system-i386 -s -S -fda itomos.bin -d guest_errors,int &
	gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c ${HEADERS}
	gcc -m32 -g -fno-pie -ffreestanding -Wall -Wextra -fno-exceptions -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	rm -rf *.bin *.o *.dis *.elf
	rm -rf kernel/*.o boot/*.o boot/*.bin drivers/*.o cpu/*.o
