_: {
	imports = [
		./client.nix
	];

	powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.logind = {
    lidSwitch = "hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=15m
    '';
  };

	systemd.sleep.extraConfig = "HibernateMode=shutdown HibernateDelaySec=10m";
}
