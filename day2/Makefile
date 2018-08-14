subdir=./kernel
all:img
helloos:helloos.asm
	nasm helloos.asm -o helloos.bin
img:helloos
	dd if=helloos.bin of=a.img count=1 bs=512
