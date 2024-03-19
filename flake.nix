{
  description = "Derek's System Flake";

  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

		nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

	outputs = inputs@{ self
		, nixpkgs, nixpkgs-unstable
		, nixos-hardware, ... }:
  let
		inputs = { inherit nixpkgs nixpkgs-unstable nixos-hardware; };

		genPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
		genUnstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };

		nixosSystem = system: hostname: username:
			let
				pkgs = genPkgs system;
				unstablePkgs = genUnstablePkgs system;
			in
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit pkgs unstablePkgs;

						customArgs = { inherit system hostname username pkgs unstablePkgs; };	
					};	

					modules = [
						./hosts/nixos/${hostname}
						#./hosts/common/nixos-common.nix
					];
				};

  in {
		nixosConfigurations = {
			framework = nixosSystem "x86_64-linux" "framework" "derek";
			#emeritus = nixosSystem "x86_64-linux" "emeritus" "derek";
		};
  };
}
