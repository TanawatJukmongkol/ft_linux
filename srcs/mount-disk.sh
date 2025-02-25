#!/usr/bin/env bash

export	IMG_DIR=${BUILD}/dist
export	IMG_PATH=${IMG_DIR}/lfs.vdi

IMG_LOOPBACK_DISK=/dev/nbd0

if [ ! -e ${LFS} ]; then
	echo '$LFS not found.'
fi

if [ ! -e ${IMG_LOOPBACK_DISK} ]; then
	echo "start NBD loopback device module..."
	modprobe nbd max_part=16
fi

echo "Mounting disk..."
qemu-nbd -c ${IMG_LOOPBACK_DISK} ${IMG_PATH}

sleep 1

# Mount root
mkdir -p          ${LFS}
mkdir -p          ${LFS}/sources
chmod a+wt        ${LFS}/sources
mkdir -p          ${LFS}/tools
mount /dev/nbd0p2 ${LFS}

# Mount swap
mkdir -p          ${LFS}/boot
mount /dev/nbd0p1 ${LFS}/boot

