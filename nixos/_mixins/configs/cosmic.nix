{ inputs
, lib
, ... 
}:
{
	services.tlp.enable = lib.mkForce false;

	services.power-profiles-daemon.enable = true;
	
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
}
