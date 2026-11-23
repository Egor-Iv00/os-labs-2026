.PHONY: all run clean

all: os.img

boot.o: boot.asm
	as --32 -o boot.o boot.asm

os.img: boot.o
	ld -m elf_i386 -Ttext 0x7C00 --oformat binary -e _start -o os.img boot.o

run: os.img
	qemu-system-i386 -drive file=os.img,format=raw,if=floppy -boot a

clean:
	rm -f boot.o os.img
