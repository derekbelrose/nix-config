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
			#../_mixins/services/stirling-pdf/default.nix
			../_mixins/configs/nvidia.nix
			#../_mixins/services/immich.nix
			../_mixins/configs/ollama.nix
			../_mixins/services/audiobookshelf.nix
			#../_mixins/services/openvscode-server.nix
			#../_mixins/services/nextcloud
			#../_mixins/containers/test1/default.nix
			#../_mixins/services/adguard.nix
    ];

	users.groups = {
		files = {};
	};
	sops.age.keyFile = "/etc/sops/age/keys.txt";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  boot.kernelModules = [ "kvm-intel" "zfs" "btrfs" ];
  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
	boot.zfs.extraPools = [ "store" ];

	systemd.network.netdevs.eno2np1.enable = true;
	systemd.network.netdevs.eno1np1.enable = true;

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

	services.open-webui = {
		enable = true;
		package = pkgs.master.open-webui;
		host = "0.0.0.0";
		openFirewall = true;
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
		cudatoolkit
		bridge-utils
		unstable.gpt4all-cuda
		master.open-webui
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
		extraPackages = with pkgs; [
			podman-compose
			nvidia-podman
		];
	};

	networking = {
		bridges.br0 = {
			interfaces = [ "eno2np1" ];
		};

		nat = {
			enable = true;
			externalInterface = "br0";
		};

		useDHCP = false;
	
		interfaces."br0".useDHCP = true;

	};
}

