#!/usr/bin/env bash

export	IMG_DIR=${BUILD}/dist
export	IMG_TYPE=vdi
export	IMG_PATH=${IMG_DIR}/lfs.vdi
export	IMG_SIZE=32G

LFS_BOOT_PRT="lfs_boot fat32      0%    600MB"
LFS_ROOT_PRT="lfs_root ext4       600MB 28GB"
LFS_SWAP_PRT="lfs_swap linux-swap 28GB  100%"

IMG_LOOPBACK_DISK=/dev/nbd0

if [ -z "${BUILD}" ]; then
	echo '$BUILD is empty.'
	exit 1
fi

if [ ! -e ${IMG_PATH} ]; then
	echo "Create image build path..."
	mkdir -p ${IMG_DIR}
	echo "Creating the disk image..."
	qemu-img create -f ${IMG_TYPE} ${IMG_PATH} ${IMG_SIZE}
else
	echo "Warning: Image already created. skipped."
fi

if [ ! -e ${IMG_LOOPBACK_DISK} ]; then
	echo "start NBD loopback device module..."
	modprobe nbd max_part=16
fi
echo "Mounting disk..."
qemu-nbd -c ${IMG_LOOPBACK_DISK} ${IMG_PATH}
sleep 1
echo "Formatting disk..."
parted -s -a optimal ${IMG_LOOPBACK_DISK} -- mklabel gpt \
"mkpart ${LFS_BOOT_PRT}" \
"mkpart ${LFS_ROOT_PRT}" \
"mkpart ${LFS_SWAP_PRT}"
mkfs.vfat ${IMG_LOOPBACK_DISK}p1
mkfs.ext4 ${IMG_LOOPBACK_DISK}p2
mkswap ${IMG_LOOPBACK_DISK}p3
echo "Unmounting disk..."
qemu-nbd -d ${IMG_LOOPBACK_DISK}
rmmod nbd
