{ pkgs
, username
, ...
}:
{
	virtualisation.lxd.enable = true;
	environment.systemPackages = with pkgs; [
		acl
		zfs
		smartmontools
	];

	users.users.${username} = {
		extraGroups = [ "lxd" ];
	};
}
