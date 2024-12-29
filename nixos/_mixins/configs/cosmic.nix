{ inputs
, lib
, ... 
}:
{
	imports = [
		inputs.nixos-cosmic.nixosModules.default
	];

	services.tlp.enable = lib.mkForce false;

	services.power-profiles-daemon.enable = true;
	
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
