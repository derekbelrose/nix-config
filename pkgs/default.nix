{	pkgs ? (import ../nixpkgs.nix) {} }: {
	bambu-studio = pkgs.callPackage ./bambu-studio { };
}
