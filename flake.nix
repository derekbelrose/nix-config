{
	description = "Derek's System Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = {self, nixpkgs, ... }: 
	let 
		lib = nixpkgs.lib;	
	in {
		nixosConfigurations = {
			emeritus = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./systems/thelio-hardware.nix
					./configuration.nix
				];
			};
			framework = lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./systems/framework-hardware.nix
					./configuration.nix
				];
			};
		};		
	};
}
