all: build/init _busybox initrd
.PHONY: all

build/init:
	@echo -e "\033[0;32mBuilding init...\033[0m"
	mkdir -p root build
	nasm -w+all -felf64 src/init.s -o build/init.o
	ld build/init.o -o build/init
	strip build/init
	cp build/init root/init

_busybox:
	@echo -e "\033[0;32mBuilding BusyBox...\033[0m"
	mkdir -p root build && cp ./busybox.config busybox/.config && cd busybox && make -j9 -l8

initrd: FORCE
	@echo -e "\033[0;32mBuilding Initial Ramdisk...\033[0m"
	( cd root; find . | cpio -o -H newc; ) | gzip -9 > initrd.cpio.gz

clean:
	rm -rf build root initramfs.cpio.gz
	cd busybox && make clean
