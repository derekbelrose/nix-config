{ inputs
, config
, lib
, pkgs
, username
, hostname
, ... }:
let
  inherit (pkgs.stdenv) isLinux;
	WOBSOCK = "/run/user/1000/wob.socket";
in
{
  imports = [
    #../../services/keybase.nix
    #../../services/syncthing.nix

    ./${hostname}.nix
    ./packages.nix
    ./sway.nix
    ./alacritty.nix
		inputs.sops-nix.homeManagerModules.sops
  ];

  sway.WOBSOCK = WOBSOCK;

	services = {
		emacs ={
			enable = true;
			defaultEditor = true;
		};
		wob = {
			enable = false;
		};
	};

	systemd.user.sessionVariables = {
		EDITOR="vim";
		MOZ_ENABLE_WAYLAND=1;
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
				pinentry = pkgs.pinentry-qt;
				lock_timeout = 0;
			};
		};
	 	ssh = {
	 		enable = true;
	 		package = pkgs.openssh;
	 		addKeysToAgent = "yes";
	 		controlMaster = "no";
	 		controlPersist = "10m";
	 		matchBlocks = {
	 			"gula" = {
	 				identityFile = "~/.ssh/gula";
	 			};
	 		};
	 	};
	 	emacs = {
	 		enable = true;
	 	};
    fuzzel = {
      enable = true;
    };
	 };
}

