{ pkgs
, lib
, ...
}:
{
	#services.displayManager.defaultSession = lib.mkForce "hyprland";
	programs = {
		hyprland = {
			enable = true;
			package = pkgs.unstable.hyprland;
			portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
			xwayland.enable = true;
		};	
		hyprlock = {
			enable = true;
		};
	};

	services.hypridle.enable = true;
	environment.systemPackages = with pkgs; [
    hyprutils
		wofi
		waybar
		libnotify
	];
}
