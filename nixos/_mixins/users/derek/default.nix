{ config, desktop, hostname, inputs, lib, pkgs, platform, username, ... } :
let
	isWorkstation = if (desktop != null) then true else false;
in
{
	environment = {
		gnome.excludePackages = with pkgs; [
			gnome-console
			gnome-text-editor
			epiphany
			geary
			gnome-music
			gnome-system-monitor
			totem
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
		]) ++ (with pkgs.unstable; lib.optionals (isWorkstation) []);
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

  users.users.derek = {
    description = "Derek Belrose";
    # mkpasswd -m sha-512
    hashedPassword = "$6$rDErRl8kpNrWYYew$QuSpE98JthX8X7BcVMyf/bmx1/3Kdf0JcKx6QFdGPIlwCX43/VNoLvolPQSpfHiCsbM6CV/ciliS2iI/Q4syh.";
		#extraGroups = [	config.users.groups.files.name ];
  };

	systemd.tmpfiles.rules = [
		"d /mnt/snapshot/${username} 0755 ${username} users"
	];
}
