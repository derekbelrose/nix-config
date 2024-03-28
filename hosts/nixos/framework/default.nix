{ lib, pkgs, unstablePkgs, specialArgs, customArgs, ... }:

{
	imports =
		[
			./hardware-configuration.nix
			../../../modules/sway.nix
			specialArgs.nixos-hardware.nixosModules.framework-13th-gen-intel
		];

  	nix.settings.experimental-features = ["flakes" "nix-command"];

  	networking.hostName = customArgs.hostname; # Define your hostname.

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		networking.networkmanager.enable = true;
	  networking.hostId = "122c8330";
	  networking.nat.enable = true;


		users.users.derek = { 		
			isNormalUser = true;
			extraGroups = [ "networkmanager" "wheel" "video" "dialout" "uinput" ];
			packages = with specialArgs.pkgs; [
				just
				vim
				firefox
			];
		};

    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

		systemd.services.systemd-udevd.restartIfChanged = false;
		systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
		systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

		services.fwupd.enable = true;
		services.tailscale.enable = true;
		services.flatpak.enable = true;

		sound.enable = true;
		hardware.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		services.xserver.enable = true;

		services.xserver.displayManager.gdm.enable = true;
		services.xserver.displayManager.gdm.wayland = true;

		services.xserver.xkb = {
			layout = "us";
			variant = "";
		};

		xdg.portal = {
			extraPortals = [ pkgs.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];
			config.common.default = "*";
			wlr.enable = true;
			enable = true;
		};

		virtualisation.libvirtd.enable = true;
		virtualisation.spiceUSBRedirection.enable = true;
		virtualisation = {
			docker = {
				enable = true;
				autoPrune = {
					enable = true;
					dates = "weekly";
				};
			};
		};

	  services.printing.enable = true;

		services.avahi = {
	    nssmdns = true;
	    enable = true;
	    ipv4 = true;
	    ipv6 = true;
	    publish = {
	      enable = true;
	      addresses = true;
	      workstation = true;
	    };
	  };

  	programs.dconf.enable = true;

		programs.gamescope.enable = true;

		programs.partition-manager.enable = true;
		programs.kdeconnect.enable = true;

		nixpkgs.config.packageOverrides = pkgs: {
 	  	intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
			steam = pkgs.steam.override {
				extraPkgs = pkgs: with pkgs; [
					gamescope
					mangohud
				];
			};
		};

		programs.steam = {
			enable = true;
			gamescopeSession.enable = true;
		};

  	environment.systemPackages = with pkgs; [
			git
	    gpu-viewer
	    brightnessctl
	    vulkan-tools
	    gpu-viewer
	    libGL
	    clinfo
	    wayland-utils
	    glxinfo
	    (vivaldi.override {
	      proprietaryCodecs = true;
	      enableWidevine = false;
	    })
	    vivaldi-ffmpeg-codecs
	    widevine-cdm
	    avizo
	    polkit
	    lxqt.lxqt-policykit
	    handbrake
		];

	  services.power-profiles-daemon.enable = lib.mkForce false;
	  services.udev.extraRules = ''
		ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness"
		ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
		ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chgrp input /sys/class/leds/%k/brightness"
		ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/leds/%k/brightness"
	  ''; 
	  services.auto-cpufreq.enable = true;
	  services.auto-cpufreq.settings = {
	    battery = {
	      governor = "powersave";
	      turbo = "never";
	    };
	    CHARGER = {
	      governor = "performance";
	      turbo = "auto";
	    };
	  };
	
	  # 18694165-78d3-4b43-8866-17026ed0ffa4
	  boot.resumeDevice = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
	  boot.kernelParams = ["mem_sleep_default=deep" "resume_offset=6967742"];


	  services.kanata = { enable = true; keyboards.default.devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"]; keyboards.default = {
	      extraDefCfg = ''
	        process-unmapped-keys yes
	      '';
	
	      config = ''
	        (defsrc
	          caps a s d f g h j k l
	        )
	
	        (deflayer mine
	          lctl a (tap-hold 200 400 s lmeta) (tap-hold 200 400 d lalt) (tap-hold 200 400 f lctl) g h (tap-hold 200 400 j rctl) (tap-hold 200 400 k ralt) (tap-hold 200 400 l rmet)
	               )
	      '';
	    };
	  };
	
	  services.logind = {
	    lidSwitch = "hibernate";
	    extraConfig = ''
	      HandlePowerKey=suspend-then-hibernate
	      IdleAction=suspend-then-hibernate
	      IdleActionSec=15m
	    '';
	  };
	
	  systemd.sleep.extraConfig = "HibernateMode=shutdown HibernateDelaySec=10m";
	  systemd.services.systemd-logind.environment = {
		SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
	  };
	  security.polkit.enable = true;
	  security.polkit.adminIdentities = [ "unix-user:${customArgs.username}" "unix-group:admin" ];
	
	  services.fwupd.package = (import (builtins.fetchTarball {
	    url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
	    sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
	  }) {
	    inherit (pkgs) system;
	  }).fwupd;
  
  	programs.light.enable = true;

	  powerManagement.enable = true;
	  powerManagement.powertop.enable = true;
	
	  services.tlp.enable = true;
	  services.blueman.enable = true;

  	security.protectKernelImage = false;
		system.stateVersion = "23.11";

	  hardware.opengl = {
	    enable = true;
	    driSupport = true;
	    extraPackages = with pkgs; [
	      intel-media-driver
	      intel-vaapi-driver
	      vaapiVdpau
	      libvdpau-va-gl
	    ];
	  };
	
	  hardware.bluetooth.enable = true;
	  hardware.bluetooth.powerOnBoot = true;

}
