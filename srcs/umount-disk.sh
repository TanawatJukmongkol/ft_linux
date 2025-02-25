#!/usr/bin/env bash

export	IMG_DIR=${BUILD}/dist
export	IMG_PATH=${IMG_DIR}/lfs.vdi

IMG_LOOPBACK_DISK=/dev/nbd0

if [ -z "${BUILD}" ]; then
	echo '$BUILD is empty.'
	exit 1
fi

if [ -e ${IMG_PATH} ]; then
	echo "Unmounting disk..."

	umount ${LFS}/boot
	rmdir  ${LFS}/boot

	umount ${LFS}
	rmdir  ${LFS}

	qemu-nbd -d ${IMG_LOOPBACK_DISK}
	rmmod nbd
fi

