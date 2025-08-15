{ inputs
, config
, pkgs
, username
, hostname
, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    #../../services/keybase.nix
    #../../services/syncthing.nix

    ./${hostname}.nix
    ./packages.nix
		./hyprland.nix
    #./sway.nix
    ./alacritty.nix
		inputs.sops-nix.homeManagerModules.sops
  ];

	services = {
		emacs ={
			enable = true;
			defaultEditor = true;
		};
	};

	systemd.user.sessionVariables = {
		EDITOR="vim";
		MOZ_ENABLE_WAYLAND=1;
    ELECTRON_OZONE_PLATFORM_HINT="auto";
	};

	pam.yubico.authorizedYubiKeys.ids = [
		"cccccbbjhhhc"
	];

	fonts.fontconfig.enable = true;

	sops = {
		age.keyFile = "/home/${username}/.config/sops/keys.txt";

		defaultSopsFile = ../../../.sops.yaml;
	};

	programs = {
	  git = {
	     userEmail = "derek@derekbelrose.com";
	     userName = "Derek Belrose";
	  };
		rbw = {
			enable = true;
			settings = {
				email = "derek@derekbelrose.com";
				base_url = "https://bitwarden.belrose.io";
			};
		};
	 	#ssh = {
	 	#	enable = true;
	 	#	package = pkgs.openssh;
	 	#	addKeysToAgent = "yes";
	 	#	controlMaster = "no";
	 	#	controlPersist = "10m";
	 	#	matchBlocks = {
	 	#	};
	 	#};
	 	emacs = {
	 		enable = true;
	 	};
    fuzzel = {
      enable = true;
    };
	 };
  
	home.file = {
		".local/bin/dimscreen.sh" = {
			source = ./scripts/dimscreen.sh;
			executable = true;
			enable = true;
		};
	};

  home.packages = [
    pkgs.firefox
    pkgs.distrobox
    pkgs.unstable.devenv
    pkgs.lmstudio
    pkgs.freetube
  ];
}

