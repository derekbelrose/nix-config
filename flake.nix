{
  description = "Derek's System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    #home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-25.05";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

		nh.url = "github:viperML/nh/v3.5.10";
		nh.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

		ollama.url = "github:abysssol/ollama-flake";
		ollama.inputs.nixpkgs.follows = "nixpkgs";
	
		ollama-flake.url = "github:shivaraj-bh/ollama-flake";
		ollama-flake.inputs.nixpkgs.follows = "nixpkgs";

 		flake-parts.url = "github:hercules-ci/flake-parts";

		agenix.url = "github:ryantm/agenix";
		agenix.inputs.nixpkgs.follows = "nixpkgs";

		sops-nix.url = "github:Mic92/sops-nix";
		sops-nix.inputs.nixpkgs.follows = "nixpkgs";

		nur.url = "github:nix-community/NUR";

    nix-comfyui.url = "github:dyscorv/nix-comfyui";
    nix-comfyui.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixinate.url = "github:matthewcroughan/nixinate";

    niri.url = "github:sodiboo/niri-flake";

    #nixos-cosmic = {
    #  url = "github:lilyinstarlight/nixos-cosmic";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nixpkgs-devenv.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";


    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # IMPORTANT

    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";

		hyprland.url = "github:hyprwm/Hyprland";
		hyprpaper.url	= "github:hyprwm/hyprpaper";
		hyprpaper.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org"; 
  };

  outputs =
    { self
    , nix-formatter-pack
		, home-manager
    , nixpkgs
		, nur
		, sops-nix
		, agenix
    , disko
    , nixinate
    , nixpkgs-devenv
    , devenv
    , chaotic 
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

      stateVersion = "24.05";

      libx = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      homeConfigurations = {
				"derek@luxuria" = 	libx.mkHome { hostname = "luxuria"; username = "derek"; desktop = "cosmic"; };
				"derek@superbia" = 	libx.mkHome { hostname = "superbia"; username = "derek"; desktop = "sway"; };
				"derek@gula" = 	libx.mkHome { hostname = "gula"; username = "derek"; };
				"derek@anywhere" = 	libx.mkHome { hostname = "anywhere"; username = "derek"; };
      };

      nixosConfigurations = {
        anywhere = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            chaotic.nixosModules.default  
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            ./nixos/anywhere
            ./nixos/anywhere/hardware-configuration.nix
          ];
        };
        # (lust) luxuria, (avarice) avaritia, (envy) invidia, (sloth) acedia, (gluttony) gula, (pride) superbia, (anger) ira
        luxuria = libx.mkHost {
          hostname = "luxuria";
          username = "derek";
          platform = "x86_64-linux";
					desktop = "sway";
        };

        gula = libx.mkHost {
					hostname = "gula";
					username = "derek";
					platform = "x86_64-linux";
				};
		
				superbia = libx.mkHost {
					hostname = "superbia";
					username = "derek";
					platform = "x86_64-linux";
				};

				clusteragent1 = libx.mkHost {
					hostname = "clusteragent1";
					username = "derek";
					platform = "x86_64-linux";
				};

 				clusteragent2 = libx.mkHost {
					hostname = "clusteragent2";
					username = "derek";
					platform = "x86_64-linux";
				};

 				clusteragent3 = libx.mkHost {
					hostname = "clusteragent3";
					username = "derek";
					platform = "x86_64-linux";
				};

        agent1 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
          ];
        };

        #tmna = nixpkgs.lib.nixosSystem {
        #  system = "x86_64-linux"
        #  modules = [];
        #}; 
      };

      devShells = libx.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      #packages.${system}.devenv-up = self.devShells.${system}.default.config.procfileScript;
      #packages.${system}.devenv-test = self.devShells.${system}.default.config.test;

      #devShells."x86_64-linux".default = devenv.lib.mkShell {
      #  inherit inputs system;
      #  modules = [
      #    ({ inputs, system, ... }: 
      #      let
      #        pkgs = inputs.nixpkgs-devenv.legacyPackages.${system};
      #      in
      #     {
      #        imports = [ ./devenv.nix ];
      #     })
      #  ];
      #};

      formatter = libx.forAllSystems (
        system:
        nix-formatter-pack.lib.mkFormatter {
          pkgs = nixpkgs.legacyPackages.${system};
          config.tools = {
            alejandra.enable = true;
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        }
      );

      overlays = import ./overlays { inherit inputs; };

      packages = libx.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legachyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }

      );
    };
}
