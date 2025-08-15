{ config, desktop, lib, pkgs, username, ... }:
let
	ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
	imports = [ 
		./root
	] ++ lib.optional(builtins.pathExists (./. + "/${username}")) ./${username};

	environment.localBinInPath = true;
		
	users.users.${username} = {
		extraGroups = [
			"audio"
			"input"
			"networkmanager"
			"users"
			"video"
			"wheel"
		] ++ ifExists [
			"docker"
			"lxd"
			"podman"
			"rtkit"
      "incus-admin"
		];

		homeMode = "0755";
		isNormalUser = true;
		packages = [ pkgs.home-manager ];
	};
}

