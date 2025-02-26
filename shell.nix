{ pkgs ? import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-19.03";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/release-19.03.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "0zisyb2a5snc3w5al6l3a8bsd06jswfqvkqg5qr78dv1xv7j36zi";
  }) {} 
}:
pkgs.mkShell {
  name = "lfs-nix";
  nativeBuildInputs = with pkgs; [
    wget
    bash
    binutils
    bison
    bzip2
    coreutils
    diffutils
    findutils
    gawk
    gcc
    glibc
    gnugrep
    gzip
    m4
    gnumake
    patch
    perl
    python3
    gnused
    gnutar
    texinfo
    xz
  ];
  shellHook = ''
    # ln -s /bin/sh /bin/bash
    LFS=/mnt/lfs
    BUILD=./build	
    IMG_PATH=./build/dist/lfs.vdi

    set +h
    umask 022
    LFS=/mnt/lfs
    LC_ALL=POSIX
    LFS_TGT=$(uname -m)-lfs-linux-gnu
    PATH=/tools/bin:$PATH
    export LFS BUILD IMG_PATH LC_ALL LFS_TGT PATH MAKEFLAGS
  '';
}
