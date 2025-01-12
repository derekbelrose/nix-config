_: {
	imports = [
		./client.nix
	];

	powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5m
    '';
  };

	systemd.sleep.extraConfig = "HibernateMode=shutdown HibernateDelaySec=10m";
}
