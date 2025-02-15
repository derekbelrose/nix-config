{ config, desktop, hostname, inputs, lib, pkgs, platform, username, ... } :
let
	isWorkstation = if (desktop != null) then true else false;
in
{
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
