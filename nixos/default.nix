{ config
, pkgs
, lib
, hostname
, username
, modulesPath
, platform
, desktop
, laptop
, inputs
, outputs
, stateVersion
, ...
}:
let
  isInstall =
    if (builtins.substring 0 4 hostname != "iso-")
    then true
    else false;

in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nh.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.nur.modules.nixos.default
		inputs.agenix.nixosModules.default
		inputs.sops-nix.nixosModules.sops
    ./${hostname}
    ./_mixins/services/tailscale.nix
    ./_mixins/configs
    ./_mixins/users
  ];

	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		defaultSopsFormat = "yaml";
		#age.keyFile = "/etc/sops/age/keys.txt";
		age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; 
	};


  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

	environment.etc = {
		#"etcsecrets" = {
		#	source = ./secrets.nix.orig;
		#	target = "nixos/secrets/secrets.nix";	
		#	enable = (hostname == "luxuria");
		#};
	};

	programs = {
		fish.enable = true;
	};

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [ "vhost_vsock" ];
    kernelParams = [
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv4.conf.all.forwarding" = 1;

      "vm.page-cluster" = 1;
    };

    loader = lib.mkIf isInstall {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.consoleMode = "max";
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  i18n = {
    defaultLocale = "en_US.utf8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.utf8";
      LC_IDENTIFICATION = "en_US.utf8";
      LC_MEASUREMENT = "en_US.utf8";
      LC_MONETARY = "en_US.utf8";
      LC_NAME = "en_US.utf8";
      LC_NUMERIC = "en_US.utf8";
      LC_PAPER = "en_US.utf8";
      LC_TELEPHONE = "en_US.utf8";
      LC_TIME = "en_US.utf8";
    };
  };

	services.xserver.xkb.layout = "us";
  time.timeZone = "America/New_York";

  documentation = {
    enable = true;
    nixos.enable = true;
    info.enable = false;
    doc.enable = false;
    man.enable = true;
  };

  security.polkit.enable = true;
  security.polkit.adminIdentities = [ "unix-user:${username}" "unix-group:admin" ];

	nh = {
		clean = {
			enable = true;
			extraArgs = "--keep-since 10d --keep 5";
		};

		enable = true;
		flake = "/home/${username}/nix-config";
	};

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise.automatic = true;

    package = lib.mkIf isInstall pkgs.unstable.nix;

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
			trusted-users = [ "derek" ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" 
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
				"https://nix-community.cachix.org"
        "https://cosmic.cachix.org/" 
      ];
    };
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "${platform}";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.unstable-packages
      outputs.overlays.master-packages
   #   outputs.overlays.modifications
    ];
	
		config = {
		};
  };

  environment = {
    defaultPackages = with pkgs;
      lib.mkForce [
        coreutils-full
        neovim
      ];

    systemPackages = with pkgs; [
			devenv
			inputs.agenix.packages."${system}".default
      git
			git-extras
      rsync
      pavucontrol
			avizo
			zellij
			sops
			gnupg
      mosh
      wayvnc
    ];
  };

  system = {
    nixos.label = lib.mkIf isInstall "-";
    stateVersion = stateVersion;
  };

  networking.networkmanager.enable = true;

  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "dialout" "uinput" "render" ];
    packages = with pkgs; [
      vim
      firefox
    ];
  };

	age.identityPaths = [
		"/etc/ssh/ssh_host_ed25519_key"
	];
}
