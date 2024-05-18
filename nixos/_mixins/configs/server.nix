{ pkgs
, ...
}:
{
	environment.systemPackages = with pkgs; [
		zfs
		bcachefs-tools
		smartmontools
	];
}
