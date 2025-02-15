{ 
	inputs
, modulesPath
, pkgs
, lib
, ...
}:{
	imports = [
		./hardware-configuration.nix
		../_mixins/configs/framework-laptop.nix
		#../_mixins/configs/cosmic.nix
		#../_mixins/configs/sway.nix
	];

	environment.systemPackages = with pkgs; [
	];


	security.protectKernelImage = false;

  programs.light.enable = true;

  #services.tlp.enable = true;
  #services.blueman.enable = true;
  #services.fstrim.enable = true;

	#services.power-profiles-daemon.enable = lib.mkForce true;

}
