{ config, outputs, pkgs, lib, inputs, ... }:

let 
in
{
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

		# This will add each flake input as a registry
		# To make nix3 commands consistent with your flake
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
		
		# This will additionally add your inputs to the system's legacy channels
		# Making legacy nix commands consistent as well, awesome!
		nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
	};

  nixpkgs = {
    overlays = [
			outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

	services.avahi.nssmdns4 = true;

	nixpkgs.config.permittedInsecurePackages = [
	];

	environment.systemPackages = with pkgs; [
		pavucontrol		
	];

	programs.gnupg.agent = {
		enable = true;
		pinentryPackage = pkgs.pinentry-qt;
		#pinentryFlavor = "qt";
		enableSSHSupport = true;
	};
}
