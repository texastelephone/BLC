#!/bin/sh
# Copyright 2017, Kenneth Jensen <kenneth@jensen.cf>
# Simple program to double check file existence
# before running qemu. 
#
# This program is part of the public domian, and
# is without warranty, implied or otherwise.

die() { echo "Error: $@"; exit 1; }

files=("build/bzImage" "build/initrd.cpio.gz")

for i in ${files[@]}; do
	[[ -f $i ]] || die "$i doesn't exist, did you run make?"
done

qemu-system-x86_64 \
	-kernel build/bzImage -initrd build/initrd.cpio.gz \
	-m 512M \
	-enable-kvm -cpu host \
	-net nic -net user \
	-nographic -serial mon:stdio \
	-append "ip=10.0.2.15"
