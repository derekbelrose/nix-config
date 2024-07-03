{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    #../../services/keybase.nix
    #../../services/syncthing.nix
  ];

	nix = {
		gc = {
			automatic = true;
			frequency = "15d";
		};
	};

	pam.yubico.authorizedYubiKeys.ids = [
		"cccccbbjhhhc"
	];

	home.packages = with pkgs; [
		foot
	];

	
	home.pointerCursor = {
		package = pkgs.breeze-gtk;
		name = "Breeze_Snow";
		size = 24;
	}; 

	programs = {
	  #fish.interactiveShellInit = ''
	  #  set -x GH_TOKEN (cat ${config.sops.secrets.gh_token.path})
	  #  set -x GITHUB_TOKEN (cat ${config.sops.secrets.gh_token.path})
	  #'';
	  git = {
	     userEmail = "derek@derekbelrose.com";
	     userName = "Derek Belrose";
	  };
	 	ssh = {
	 		enable = true;
	 		package = pkgs.openssh;
	 		addKeysToAgent = "yes";
	 		controlMaster = "auto";
	 		controlPersist = "10m";
	 		matchBlocks = {
	 			"github.com" = {
	 				user = "git";
	 				identityFile = "~/.ssh/github";
	 			};
	 			"gula" = {
	 				identityFile = "~/.ssh/gula";
	 			};
	 		};
	 	};
	 	emacs = {
	 		enable = true;
	 	};
	 	firefox = {
	 		enable = true;
	 		package = pkgs.firefox-wayland;
	 	};
	 	alacritty = {
	 		enable = true;
	 		settings = {
	 			cursor.style = {
	 				shape = "beam";
	 				blinking = "on";
	 			};
	 			font = {
	 				size = 12;
	 				normal = {
	 					family = "FiraMono Nerd Font"; 
	 					style = "Regular";
	 				};
	 				bold = {
	 					family = "FiraMono Nerd Font";
	 					style = "Bold";
	 				};
	 				italic = {
	 					family = "FiraMono Nerd Font";
	 					style = "Italic";
	 				};
	 			};
	 			colors = {
	 				primary = {
	 					background = "0x2D0D16";
	 					foreground = "0xf8f8f0";
	 				};
	 				normal = {
	 					black = "0x464258";
	 					red = "0xff857f";
	 					green = "0xad5877";
	 					yellow = "0xe6c000";
	 					blue = "0x6c71c4";
	 					magenta = "0xb267e6";
	 					cyan = "0xafecad";
	 					white = "0xcccccc";
	 				};
	 				bright = {
	 					black = "0xc19fd8";
	 					red = "0xf44747";
	 					green = "0xffb8d1";
	 					yellow = "0xffea00";
	 					blue = "0x6796e6";
	 					magenta = "0xc5a3ff";
	 					cyan = "0xb2ffdd";
	 					white = "0xf8f8f0";
	 				};
	 			};
	 		};
	 	};
	 };

	#home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 
	#home.file.".config/alacritty/alacritty.toml".source =  ./sources/alacritty.toml;


	home.file.".icons/default".source = "${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita";

	gtk = {
		enable = true;
		iconTheme.name = "Papirus";
		iconTheme.package = pkgs.papirus-icon-theme;
		theme.name = "Yaru-dark";
		theme.package = pkgs.yaru-theme;
		cursorTheme.package = pkgs.breeze-gtk;
		cursorTheme.name = "Breeze_Snow";
	};

  #sops = {
  #  age = {
  #    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #    generateKey = false;
  #  };
  #  defaultSopsFile = ../../../../secrets/secrets.yaml;
  #  # sops-nix options: https://dl.thalheim.io/
  #  secrets = {
  #    asciinema.path = "${config.home.homeDirectory}/.config/asciinema/config";
  #    atuin_key.path = "${config.home.homeDirectory}/.local/share/atuin/key";
  #    flakehub_netrc.path = "${config.home.homeDirectory}/.local/share/flakehub/netrc";
  #    flakehub_token.path = "${config.home.homeDirectory}/.config/flakehub/auth";
  #    gh_token = {};
  #    gpg_private = {};
  #    gpg_public = {};
  #    gpg_ownertrust = {};
  #    halloy_config.path = "${config.home.homeDirectory}/.config/halloy/config.toml";
  #    hueadm.path = "${config.home.homeDirectory}/.hueadm.json";
  #    obs_secrets = {};
  #    ssh_config.path = "${config.home.homeDirectory}/.ssh/config";
  #    ssh_key.path = "${config.home.homeDirectory}/.ssh/id_rsa";
  #    ssh_pub.path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
  #    ssh_semaphore_key.path = "${config.home.homeDirectory}/.ssh/id_rsa_semaphore";
  #    ssh_semaphore_pub.path = "${config.home.homeDirectory}/.ssh/id_rsa_semaphore.pub";
  #    transifex.path = "${config.home.homeDirectory}/.transifexrc";
  #  };
  #};

  # Linux specific configuration
  #systemd.user.tmpfiles.rules = lib.mkIf isLinux [
  #  "L+ ${config.home.homeDirectory}/.config/obs-studio/ - - - - ${config.home.homeDirectory}/Studio/OBS/config/obs-studio/"
  #];
}

