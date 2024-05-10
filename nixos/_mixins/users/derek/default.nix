{ config, desktop, hostname, inputs, lib, pkgs, platform, username, ... } :
let
	isWorkstation = if (desktop != null) then true else false;
in
{
	environment = {
		gnome.excludePackages = with pkgs; [
			gnome-console
			gnome-text-editor
			gnome.epiphany
			gnome.geary
			gnome.gnome-music
			gnome.gnome-system-monitor
			gnome.totem
		];
		
		systemPackages = (with pkgs; [
			bitwarden-cli
		] ++ lib.optionals(isWorkstation) [
			bitwarden
			bitwarden-menu
			brave
			chromium
			element-desktop
			gnome.dconf-editor
			gnome.gnome-tweaks
			brave
		]) ++ (with pkgs.unstable; lib.optionals (isWorkstation) [
			fractal
		]);
	};

	programs = {
		dconf.enable = true;
		chromium = lib.mkIf (isWorkstation) {
			extensions = [
				"nngceckbapebfimnlniiiahkandclblb" # Bitwarden
				"gebbhagfogifgggkldgodflihgfeippi" # Return Youtube Dislike
				"mnjggcdmjocbbbhaepdhchncahnbgone" # Sponsorblock for Youtube
			];
		};

		dconf.profiles.user.databases = [{
  	  settings = with lib.gvariant; lib.mkIf (isWorkstation) {
  	  };
  	}];
	};

  #gtk = {
  #  enable = true;
  #  theme = {
  #    package = pkgs.gnome.gnome-themes-extra;
  #    name = "Adwaita-dark";
  #  };
  #};

  users.users.derek = {
    description = "Derek Belrose";
    # mkpasswd -m sha-512
    hashedPassword = "$6$rDErRl8kpNrWYYew$QuSpE98JthX8X7BcVMyf/bmx1/3Kdf0JcKx6QFdGPIlwCX43/VNoLvolPQSpfHiCsbM6CV/ciliS2iI/Q4syh.";
  };

	systemd.tmpfiles.rules = [
		"d /mnt/snapshot/${username} 0755 ${username} users"
	];
}
