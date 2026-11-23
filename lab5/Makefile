.PHONY: all run clean

all: os.img

boot.o: boot.asm
	as --32 -o boot.o boot.asm

boot.bin: boot.o
	ld -m elf_i386 -Ttext 0x7C00 --oformat binary -e _start -o boot.bin boot.o

maze.o: maze.asm
	as --32 -o maze.o maze.asm

maze.bin: maze.o
	ld -m elf_i386 -Ttext 0x8000 --oformat binary -e _start -o maze.bin maze.o

os.img: boot.bin maze.bin
	cat boot.bin maze.bin > os.img
	truncate -s 1474560 os.img

run: os.img
	qemu-system-i386 -drive file=os.img,format=raw,if=floppy -boot a

clean:
	rm -f boot.o boot.bin maze.o maze.bin os.img
