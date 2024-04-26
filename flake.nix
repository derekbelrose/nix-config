{
  description = "Derek's System Flake";

  inputs = {
		#nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nixpkgs-master.url = "github:NixOS/nixpkgs";

		nixos-hardware.url = "github:NixOS/nixos-hardware?ref=1e679b9";
		nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";
  };

	outputs = inputs@{ self
		, nixpkgs, nixpkgs-unstable, nixpkgs-master
		, nixpkgs-wayland, nixos-hardware, nix-formatter-pack, ... }:
  let
		inherit (self) outputs system;
		stateVersion = "23.11";

		inputs = { inherit nixpkgs nixpkgs-unstable nixos-hardware nixpkgs-wayland;};

		genPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
		genUnstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
		genMasterPkgs = system: import nixpkgs-master { inherit system; config.allowUnfree = true; };

		nixosSystem = system: hostname: username:
			let
				pkgs = genPkgs system;
				unstablePkgs = genUnstablePkgs system;
				masterPkgs = genMasterPkgs system;
			in 
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit inputs system outputs hostname username stateVersion pkgs unstablePkgs masterPkgs;
					};	

					modules = [
						./hosts/nixos/${hostname}
						./hosts/common/nixos-common.nix
					];
				};

		libx = import ./lib { inherit inputs outputs stateVersion; };
  in {
		nixosConfigurations = {
			framework = nixosSystem "x86_64-linux" "framework" "derek";
			emeritus = nixosSystem "x86_64-linux" "emeritus" "derek";
			mediaserver = nixosSystem "x86_64-linux" "mediaserver" "derek";
		};

    # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
    #devShells = libx.forAllSystems (system:
    #  let pkgs = nixpkgs.legacyPackages.${system};
    #  in import ./shell.nix { inherit pkgs; }
    #);


    # nix fmt
    formatter = libx.forAllSystems (system:
      nix-formatter-pack.lib.mkFormatter {
        pkgs = nixpkgs.legacyPackages.${system};
        config.tools = {
          alejandra.enable = false;
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
        };
      }
    );

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays { inherit inputs; };

    # Custom packages; acessible via 'nix build', 'nix shell', etc
    #packages = libx.forAllSystems (system:
    #  let pkgs = nixpkgs.legacyPackages.${system};
    #  in import ./pkgs { inherit pkgs; }
    #);
  };
}
