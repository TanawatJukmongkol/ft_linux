{
	description = "LFS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		flake-utils.url = "github:numtide/flake-utils";
	};
	outputs = {
		self,
		nixpkgs,
		flake-utils,
		...
	}: flake-utils.lib.eachDefaultSystem ( system :
		let
			pkgs = (import nixpkgs {
				inherit system;
			});
			pkgs_legacy = import (builtins.fetchTarball {
				url = "https://github.com/NixOS/nixpkgs/archive/9748e9ad86159f62cc857a5c72bc78f434fd2198.tar.gz";
				sha256 = "1k6mdfnwwwy51f7szggyh2dxjwrf9q431c0cnbi17yb21m9d4n26";
			}) { inherit system; };
		in {
			devShells.default = (pkgs.buildFHSUserEnv.override {
				stdenv.cc = pkgs_legacy.stdenv.cc;
			}) {
				name = "lfs-nix";
				src = ./srcs;
				targetPkgs = p: (with pkgs; [
					parted
					wget
				]) ++ (with pkgs_legacy; [
					bash
					gnumake
					bison
					gcc
					m4
				]);
				shellHook = ''
					ln -s /bin/sh /bin/bash
				'';
				profile = ''
					LFS=/mnt/lfs
					BUILD=./build	
					IMG_PATH=./build/dist/lfs.vdi

					set +h
					umask 022
					LFS=/mnt/lfs
					LC_ALL=POSIX
					LFS_TGT=$(uname -m)-lfs-linux-gnu
					PATH=/tools/bin:/bin:/usr/bin:$PATH
					export LFS BUILD IMG_PATH LC_ALL LFS_TGT PATH MAKEFLAGS
				'';
			};
		}
	);
}
