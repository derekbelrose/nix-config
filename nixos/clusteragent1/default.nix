# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ modulesPath, system, outputs, inputs, config, lib, pkgs, hostname, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #(import ./disko.nix { })
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./hardware-configuration.nix
      ../_mixins/configs/server.nix
      ../_mixins/services/openssh.nix
			../_mixins/services/k3s/agent.nix
      ./disk-config.nix
    ];

	users.groups = {
		files = {};
	};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelModules = [ "kvm-amd" "btrfs" ];
	boot.zfs.extraPools = [ "store" ];

	boot.kernelParams = [ "video=1024x768" ];

	#systemd.network.netdevs.eno2np1.enable = true;
	#systemd.network.netdevs.eno1np1.enable = true;

  networking.hostId = "2f34b05d";

	services.systembus-notify.enable = true;
	services.smartd = {
		enable = true;
		autodetect = true;
		notifications = {
			wall.enable = true;
		};
	};

  time.timeZone = "America/New_York";

	nixpkgs = {
		config.allowUnfree = true;
	};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = true;
  users.users.derek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "files" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
    initialHashedPassword = "$y$j9T$1lFGGWTz8puEltvBQzxUL/$C07rsZq4087Gg7bH9oREX7PqqU37G0Tp7s42cLzy/X8";
  };

  users.users.derek.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDV2IDdbm2A/xbvZapaYSEngi3qP4Ty9W8+jusPiNQu derek@superbia"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
		bridge-utils
		#master.open-webui
   ];

	virtualisation.podman = {
		#enableNvidia	= true;
		enable = false;
		extraPackages = with pkgs; [
			podman-compose
		];
	};

	virtualisation.docker = {
		enable = false;
		rootless = {
			enable = false;
			setSocketVariable = true;
		};
		daemon = {
			settings = {
				data-root = "/store/docker-data/";
			};
		};
	};
	
	#networking = {
		#bridges.br0 = {
		#	interfaces = [ "eno2np1" ];
		#};

		#nat = {
		#	enable = true;
		#	externalInterface = "br0";
		#};

		#useDHCP = false;
	
		#interfaces."br0".useDHCP = true;

	#};

	console = lib.mkForce {
    font = "ter-powerline-v24b";
    packages = [
      pkgs.terminus_font
      pkgs.powerline-fonts
    ];
	};
}

