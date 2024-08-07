{ pkgs
, username
, ...
}:
{
	virtualisation.lxd.enable = true;
	environment.systemPackages = with pkgs; [
		acl
		zfs
		bcachefs-tools
		smartmontools
	];

	users.users.${username} = {
		extraGroups = [ "lxd" ];
	};
}
