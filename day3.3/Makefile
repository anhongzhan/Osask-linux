subdir=./kernel
all:img
helloos:helloos.asm
	nasm helloos.asm -o helloos.bin
img:helloos
	dd if=helloos.bin of=a.img count=1 bs=512
run:
	qemu-system-i386 -drive file=a.img,if=floppy
clean:
	rm helloos.bin a.img
