{
  description = "Derek's System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    ...
  }: let
    lib = nixpkgs.lib;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
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
	  nixos-hardware.nixosModules.framework-13th-gen-intel
          ./configuration.nix
          ./systems/framework-hardware.nix
        ];
      };
    };
  };
}
