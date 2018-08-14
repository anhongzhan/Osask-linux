subdir=./kernel
all:img
boot:
	nasm helloos.asm -o helloos
	nasm harbote.asm -o harbote.bin
img:boot
	dd if=helloos of=myos.img count=1 bs=512
	dd if=/dev/zero of=myos.img bs=512 seek=1 skip=1 count=2879
copy:
	mkdir -p /tmp/floppy
	mount -o loop myos.img /tmp/floppy -o fat=12
	sleep 1
	cp harbote.bin /tmp/floppy
	sleep 1
	umount /tmp/floppy
run:
	bochs
