{ pkgs
, username
, ...
}:
{
	virtualisation.lxd.enable = true;
	environment.systemPackages = with pkgs; [
		zfs
		bcachefs-tools
		smartmontools
	];

	users.users.${username} = {
		extraGroups = [ "lxd" ];
	};
}
