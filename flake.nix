{
  description = "Derek's System Flake";

  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

		nix-darwin.url = "github:lnl7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

		home-manager.url = "github:nix-community/home-manager/release-23.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		disko.url = "github:nix-community/disko";
		disko.inputs.nixpkgs.follows = "nixpkgs";

		vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

	outputs = inputs@{ self
		, nixpkgs, nixpkgs-unstable, nixpkgs-darwin
		, home-manager, nix-darwin, disko, vscode-server, nixos-hardware, ... }:
  let
		inputs = { inherit disko home-manager nixpkgs nixpkgs-unstable nix-darwin; };

		genPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
		genUnstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
		genDarwinPkgs = system: import nixpkgs-darwin { inherit system; config.allowUnfree = true; };

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
