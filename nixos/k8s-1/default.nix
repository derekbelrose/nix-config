# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ system, outputs, inputs, config, lib, pkgs, hostname, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      (import ./disko.nix { })
      ./hardware-configuration.nix
      ../_mixins/configs/server.nix
      ../_mixins/services/openssh.nix
			../_mixins/services/k3s/agent.nix
    ];

	users.groups = {
		files = {};
	};
	sops.age.keyFile = "/etc/sops/age/keys.txt";

	#sops.secrets.token = {
	#	sopsFile = ../../secrets/test.yaml.enc;
	#	format = "json";
	#	owner = "derek";
	#	group = "derek";
	#};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelModules = [ "kvm-amd" "btrfs" ];
	boot.zfs.extraPools = [ "store" ];

	boot.kernelParams = [ "video=1024x768" ];

	#systemd.network.netdevs.eno2np1.enable = true;
	#systemd.network.netdevs.eno1np1.enable = true;

  networking.hostName = "k8s-1"; # Define your hostname.
  networking.hostId = "8425e349";

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
  users.users.derek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "files" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

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

