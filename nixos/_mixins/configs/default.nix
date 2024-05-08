{ hostname, lib, pkgs, ... }:
let
	boot-host = import ./boot-host.nix { inherit pkgs; };
	build-host = import ./build-host.nix { inherit pkgs; };
	build-all = import ./build-all.nix { inherit pkgs; };
	unroll-url = import ./unroll-url.nix { inherit pkgs; };
in
{
	environment.systemPackages = [
		boot-host
		build-host
		build-all
	
		unroll-url
	];
}
