{
  description = "Derek's System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=1e679b9";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nix-formatter-pack
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;

      stateVersion = "23.11";

      libx = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      #homeConfigurations = {
      #
      #};

      nixosConfigurations = {
        # (lust) luxuria, (avarice) avaritia, (envy) invidia, (sloth) acedia, (gluttony) gula, (pride) superbia, (anger) ira
        luxuria = libx.mkHost {
          hostname = "luxuria";
          username = "derek";
          platform = "x86_64-linux";
        };
      };

      devShells = libx.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

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
