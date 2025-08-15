{ pkgs
, lib
, inputs
, ...
}:
{
	#services.displayManager.defaultSession = lib.mkForce "hyprland";
	programs = {
		hyprland = {
			enable = true;
			withUWSM = true;
			package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
			portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
			xwayland.enable = true;
		};	
	};
}
