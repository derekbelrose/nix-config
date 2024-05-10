{pkgs, ... } :
{
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	environment.systemPackages = with pkgs; [
		gnome.adwaita-icon-theme
	];
}
