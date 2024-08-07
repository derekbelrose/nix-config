# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ system, outputs, inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      (import ./disk-config.nix { })
      ./hardware-configuration.nix
      ../_mixins/configs/server.nix
      ../_mixins/services/openssh.nix
			../_mixins/services/jellyfin.nix
			../_mixins/services/mealie/default.nix
			../_mixins/services/stirling-pdf/default.nix
			#../_mixins/services/plex.nix
			../_mixins/configs/nvidia.nix
			../_mixins/services/immich.nix
			../_mixins/configs/ollama.nix
			#../_mixins/services/openvscode-server.nix
			#../_mixins/services/nextcloud
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "bcachefs" "zfs" ];

  boot.kernelModules = [ "kvm-intel" "zfs" "bcachefs" ];
  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
	boot.zfs.extraPools = [ "store" ];

	systemd.network.netdevs.eno2np1.enable = true;
	systemd.network.netdevs.eno1np1.enable = true;

	#systemd.services.mount-store = {
	#	description = "Mount bcachefs /store";
	#	script = "/run/current-system/sw/bin/mount -t bcachefs /dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N0MAR4RJ:/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WMC4N0M3REZC:/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N6FT8CJC:/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N4PP8377:/dev/disk/by-id/ata-CT1000P3SSD8_2307E6ABF4BC:/dev/disk/by-id/ata-ST4000VN008-2DR166_ZGY6VHBS:/dev/disk/by-id/ata-ST4000VN008-2DR166_ZM40Z1YD:/dev/disk/by-id/ata-ST4000VN008-2DR166_ZM40ZH68:/dev/disk/by-id/ata-ST12000VN0008-2PH103_ZTN1CLT3:/dev/disk/by-id/ata-ST12000VN0008-2YS101_ZRT1FXD9 /store";
	#	wantedBy = [ "multi-user.target" ];
	#	enable = true;
	#};


  networking.hostName = "gula"; # Define your hostname.
  networking.hostId = "2cbc7865";


	services.zfs.autoScrub.enable = true;
	services.systembus-notify.enable = true;
	services.smartd = {
		enable = true;
		autodetect = true;
		notifications = {
			wall.enable = true;
		};
	};
  # Set your time zone.
  time.timeZone = "America/New_York";

	nixpkgs = {
		config.allowUnfree = true;
	};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.derek = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      vim
      just
      git
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
		nvidia-vaapi-driver
		bcachefs-tools
		cudatoolkit
		bridge-utils
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date,127.0.0.1/8 out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

	hardware.nvidia-container-toolkit.enable = true;

	virtualisation.podman = {
		#enableNvidia	= true;
		enable = true;
		dockerCompat = false;
		extraPackages = with pkgs; [
			podman-compose
			nvidia-podman
		];
	};

	networking = {
		#nat = {
		#	enable = true;
		#	externalInterface = "br0";
		#};

		#bridges.br0.interfaces = [ "eno1" ];

		#useDHCP = false;
		#interfaces."br0".useDHCP = true;

		#interfaces."br0".ipv4.addresses = [ {
		#	address = "10.0.1.1";
		#	prefixLength = 24;
		#}];
	};

  #system.stateVersion = "24.05"; # Did you read the comment?

}

