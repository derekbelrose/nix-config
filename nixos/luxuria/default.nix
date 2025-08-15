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

	boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
	environment.systemPackages = with pkgs; [
		thunderbird
#		hyprlauncher
#		hyprcursor
#		hyprpaper
#		hypridle
#		hyprlock
#		hyprpicker
		meson
		cmake
		cpio
		waybar
	];


	security.protectKernelImage = false;

  programs.light.enable = true;

	programs.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
	};


  #services.tlp.enable = true;
  #services.blueman.enable = true;
  services.fstrim.enable = true;

	#services.power-profiles-daemon.enable = lib.mkForce true;

}
