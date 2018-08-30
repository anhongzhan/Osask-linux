subdir=./kernel
all:img
boot:
	nasm helloos.asm -o helloos
	nasm harbote.asm -o harbote.bin
img:boot
	dd if=helloos of=a.img count=1 bs=512
	dd if=/dev/zero of=a.img bs=512 seek=1 skip=1 count=2879
copy:
	mkdir -p /tmp/floppy
	mount -o loop a.img /tmp/floppy -o fat=12
	sleep 1
	cp harbote.bin /tmp/floppy
	sleep 1
	umount /tmp/floppy
run:
	qemu-system-i386 -drive file=a.img,if=floppy
clean:
	rm helloos a.img harbote.bin
