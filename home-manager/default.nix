{ config, desktop, hostname, inputs, lib, outputs, pkgs, stateVersion, username, ... }:
let
	inherit (pkgs.stdenv) isDarwin isLinux;
	isWorkstation = if (desktop != null) then true else false;
in
{
	imports = [
		./_mixins/users/${username}
	]; 
	#++ lib.optional (builtins.pathExists (./. + "/_mixins/users/${username}")) ./_mixins/users/${username}
  #++ lib.optional (builtins.pathExists (./. + "/_mixins/hosts/${hostname}")) ./_mixins/hosts/${hostname}
  #++ lib.optional (isWorkstation) ./_mixins/desktop;

	home = {
		inherit stateVersion;
		inherit username;
		homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

		packages = with pkgs; [
			unzip
			wget
			jiq
			neo-cowsay
			cpufetch
			dconf2nix
			du-dust
			glow
			pciutils
			s-tui
			neovim
			fira-code-symbols
			bc
		];

		sessionVariables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
			SYSTEMD_EDITOR = "nvim";
			PAGER = "bat";
		};
	};

	fonts.fontconfig.enable = true;
	
	news.display = "silent";

	nixpkgs = {
		overlays = [
			outputs.overlays.additions
			outputs.overlays.unstable-packages
		];

		config = {
			allowUnfree = true;
			allowUnfreePredicate = _: true;
		};
	};

	nix = {
		registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

		package = pkgs.unstable.nix;
		settings = {
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
			#netrc-file = 	
			extra-trusted-substituters = "https://cache.flakehub.com/";
			extra-trusted-public-keys = "cache.flakehub.com-1:t6986ugxCA+d/ZF9IeMzJkyqi5mDhvFIx7KA/ipulzE= cache.flakehub.com-2:ntBGiaKSmygJOw2j1hFS7KDlUHQWmZALvSJ9PxMJJYU=";
			keep-outputs = true;
			keep-derivations = true;
			warn-dirty = false;
		};
	};

	programs = {
		bat = {
			enable = true;
			extraPackages = with pkgs.bat-extras; [
				batgrep
				batwatch
				prettybat
			];

			config = {
				style = "plain";
			};
		};
		dircolors = {
			enable = true;
			enableBashIntegration = true;
			enableFishIntegration = true;
			enableZshIntegration = true;
		};
		direnv = {
			enable = true;
			enableBashIntegration = true;
			enableFishIntegration = true;
			nix-direnv = {
				enable = true;	
			};
		};
		zoxide = {
			enable = true;
			enableBashIntegration = true;
			enableFishIntegration = true;
			enableZshIntegration = true;

			options = [
				"--cmd cd"
			];
		};
	};

	systemd.user.startServices = lib.mkIf isLinux "sd-switch";

	xdg = {
		enable = isLinux;
		userDirs = {
			enable = isLinux;
			createDirectories = lib.mkDefault true;
			extraConfig = {
				XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
			};
		};
	};
}
