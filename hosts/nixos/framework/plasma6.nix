{ unstablePkgs, ... }:

{
	disabledModules = [ "services/desktop-managers/plasma5.nix" ];

	imports = [
		"${unstablePkgs}/nixos/modules/services/desktop-managers/plasma6.nix"
	];
}
