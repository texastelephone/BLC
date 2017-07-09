.PHONY: all

all: init busybox initramfs
	mkdir -p root build

initrd:
	( cd root; find . | cpio -o -H newc; ) | gzip -9 > initramfs.cpio.gz

init:
	nasm -w+all -felf64 src/init.s -o build/init.o
	ld build/init.o -o build/init
	strip build/init
	cp build/init root/init

busybox:
	cp ./busybox.config busybox/.config
	cd busybox
	make 

clean:
	rm -r build root
	cd busybox && make clean
