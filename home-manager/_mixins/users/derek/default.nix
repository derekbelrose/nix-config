{ inputs
, config
, lib
, pkgs
, username
, hostname
, ... }:
let
  inherit (pkgs.stdenv) isLinux;
	modKey = "Mod4";
	ws1 = "1 - Communication";
	ws2 = "2 - Browsing";
	ws3 = "3 - Making";
	ws4 = "4 - Writing";
	ws5 = "5 - Homelab";
	ws6 = "6 - Home Assistant";
	ws7 = "7 - Work";
	ws8 = "8 - Learning";
	ws9 = "9 - More";
	ws10 = "10 - Even more";

	WOBSOCK = "/run/user/1000/wob.socket";

in
{
  imports = [
    #../../services/keybase.nix
    #../../services/syncthing.nix

    ./${hostname}.nix
		inputs.sops-nix.homeManagerModules.sops
  ];

	services = {
		emacs ={
			enable = true;
			defaultEditor = true;
		};
		wob = {
			enable = true;
		};
	};

	nix = {
		gc = {
			automatic = true;
			frequency = "15d";
		};
	};

	wayland.windowManager.sway = {
		enable = true;
		checkConfig = true;	
		swaynag = {
			enable = true;
			settings = {};
		};
		systemd = {
			enable = true;
			xdgAutostart = true;
		};
		config = {
			startup = [
				{ command = "sleep 5; swaymsg ${ws1}:"; }
			];
			modifier = modKey;
			terminal = "${pkgs.alacritty}/bin/alacritty";
			gaps = {
				inner = 5;
				outer = 3;
			};
			window.titlebar = false;
			
			keybindings = let
				inherit (config.wayland.windowManager.sway.config) modifier terminal;
			in lib.mkAfter {
				# Exit Sway
				"${modKey}+Shift+Control+q" = "exit";
				# Move Between Workspaces
				"${modKey}+1" = "workspace ${ws1}";
				"${modKey}+2" = "workspace ${ws2}";
				"${modKey}+3" = "workspace ${ws3}";
				"${modKey}+4" = "workspace ${ws4}";
				"${modKey}+5" = "workspace ${ws5}";
				"${modKey}+6" = "workspace ${ws6}";
				"${modKey}+7" = "workspace ${ws7}";
				"${modKey}+8" = "workspace ${ws8}";
				"${modKey}+9" = "workspace ${ws9}";
				"${modKey}+0" = "workspace ${ws10}";

        # Move Active Container to a specific workspaces
				"${modKey}+Shift+1" = "move container to workspace ${ws1}";
				"${modKey}+Shift+2" = "move container to workspace ${ws2}";
				"${modKey}+Shift+3" = "move container to workspace ${ws3}";
				"${modKey}+Shift+4" = "move container to workspace ${ws4}";
				"${modKey}+Shift+5" = "move container to workspace ${ws5}";
				"${modKey}+Shift+6" = "move container to workspace ${ws6}";
				"${modKey}+Shift+7" = "move container to workspace ${ws7}";
				"${modKey}+Shift+8" = "move container to workspace ${ws8}";
				"${modKey}+Shift+9" = "move container to workspace ${ws9}";
				"${modKey}+Shift+0" = "move container to workspace ${ws10}";


				# Move Focus
				"${modKey}+left" = "focus left";
				"${modKey}+Right" = "focus right";
				"${modKey}+Up" = "focus up";
				"${modKey}+Down" = "focus down";

				#Move focused window
				"${modKey}+Shift+Left" = "move left";
				"${modKey}+Shift+Right" = "move right";
				"${modKey}+Shift+Up" = "move up";
				"${modKey}+Shift+Down" = "move down";

				# Shortcuts
				"${modKey}+Return" = "exec ${terminal}";
				"${modKey}+Shift+q" = "kill";
				"${modKey}+Shift+c" = "reload";
				"${modKey}+b" = "splith";
				"${modKey}+v" = "splitv";

				# Switch current container to different layouts
				"${modKey}+s" = "stacking";
				"${modKey}+w" = "tabbed";
				"${modKey}+e" = "toggle split";
	
				# Fullscreen
				"${modKey}+f" = "fullscreen";

				# Current container toggle floating
				"${modKey}+Shift+space" = "floating toggle";
			
				# Swap focus betweenthe tiling area and the floating area
				"${modKey}+space" = "focus mode_toggle";

				# Move focus to parent container
				"${modKey}+a" = "focus parent";

				# Move the focused window to the scratchpad
				"${modKey}+Shift+minus" = "move scratchpad";

				# Show the next scratchpad window. Cycles if multiple
				"${modKey}+minus" = "scratchpad show";

				# Start applications
				"${modKey}+Shift+b" = "exec ${pkgs.firefox}/bin/firefox";

				# Emacs client
				"${modKey}+Alt+e" = "exec ${pkgs.emacs}/bin/emacsclient -c";

				# Media Keys
				XF86AudioMute = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{printf \"%s\", $5}' > ${WOBSOCK}";
				XF86AudioRaiseVolume = "exec ${pkgs.pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
  			XF86AudioLowerVolume = "exec ${pkgs.pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
			};

			workspaceAutoBackAndForth = true;
		};
	};

	systemd.user.sessionVariables = {
		EDITOR="vim";
		MOZ_ENABLE_WAYLAND=1;
	};

	pam.yubico.authorizedYubiKeys.ids = [
		"cccccbbjhhhc"
	];

	home.packages = with pkgs; [
		wob
		foot
    alacritty
		fractal
		orca-slicer
    yubikey-personalization
    tmux
    zellij
    chromium
    gnome.gnome-settings-daemon
    unstable.anytype
    kdePackages.ksshaskpass
    hyprland
    fira
    nerdfonts
    logisim-evolution
    pinentry-qt
    swaynotificationcenter
    yarn
    wayland-utils

		#Fonts
		(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    source-code-pro
    source-sans-pro
    source-serif-pro
    font-awesome
    ibm-plex
    jetbrains-mono
    fira-code
    fira-code-symbols
    fira
    nerdfonts
    powerline-fonts
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
    fuzzel = {
      enable = true;
    };
	 };
}

