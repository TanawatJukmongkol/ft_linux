# ft_linux

## What is this?

This project is a 42 school project aiming to create a LFS system v8.4 for driver development. The goal is to create a declarative and deterministic environment for building custom LFS on the machine host natively to create a live bootable disk image.

## How to use:
`sudo nix develop` to enter the dev shell as root

`./srcs/lfs-kvm.sh` to generate the disk and partition it.

`./srcs/(u)mount-disk.sh` to mount/unmount the vdi

`./srcs/version-check.sh` to check the versions of the dependencies in devshell
