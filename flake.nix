{
  description = "Derek's System Flake";

  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

		home-manager.url = "github:nix-community/home-manager/release-23.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

	outputs = inputs@{ self
		, nixpkgs, nixpkgs-unstable
		, home-manager, nix-darwin, nixos-hardware, ... }:
  let
		inputs = { inherit home-manager nixpkgs nixpkgs-unstable nix-darwin; };

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
