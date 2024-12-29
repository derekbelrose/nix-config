{ 
	inputs
, modulesPath
, pkgs
, ...
}:{
	imports = [
		./hardware-configuration.nix
		../_mixins/configs/framework-laptop.nix

		../_mixins/configs/cosmic.nix
		../_mixins/configs/sway.nix
		#inputs.home-manager.nixosModules.home-manager {
		#	home-manager.useGlobalPkgs = true;
		#	home-manager.useUserPackages = true;
		#	home-manager.users.derek = import ../../home-manager/_mixins/users/derek;
		#}
	];

	environment.systemPackages = with pkgs; [
		freecad
	];


	security.protectKernelImage = false;

  programs.light.enable = true;

  services.tlp.enable = true;
  services.blueman.enable = true;
  services.fstrim.enable = true;

}
