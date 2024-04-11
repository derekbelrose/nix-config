{ pkgs, lib, inputs, ... }:

let 
	inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
	imports = [
	];
	time.timeZone = "America/New_York";

	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			warn-dirty = false;
		};

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 5";
		};
	};

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.permittedInsecurePackages = [

	];

	environment.systemPackages = with pkgs; [
		pavucontrol		
	];

	programs.gnupg.agent = {
		enable = true;
		pinentryFlavor = "qt";
		enableSSHSupport = true;
	};
}
