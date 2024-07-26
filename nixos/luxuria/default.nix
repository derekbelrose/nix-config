{ outputs
, config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../_mixins/services/samba.nix
    ../_mixins/configs/laptop.nix
    ../_mixins/configs/gnome.nix
		# mealie dev testing
    # ../_mixins/services/mealie/default.nix
    # ../_mixins/services/stirling-pdf/default.nix
    ../../modules/sway.nix
    ../../modules/suspend-then-hibernate.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "sg" ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

  	resumeDevice = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
  	kernelParams = [ "mem_sleep_default=deep" "resume_offset=6967742" "nvme.noacpi=1"];
  };

  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "wlp170s0";

  nixpkgs.overlays = [ 
		outputs.overlays.additions 
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    options = [ "subvol=swap" "noatime" "nodatacow" "nospace_cache" ];
    fsType = "btrfs";
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "b07b1268";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.fwupd = {
		enable = true;
		extraRemotes = [ "lvfs-testing" ];
	};
	
  services.tailscale.enable = true;
  services.fprintd.enable = true;

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

  services.xserver.displayManager = {
    gdm = {
      enable = lib.mkForce false;
      wayland = true;
    };
		sddm = {
			enable = true;
			wayland.enable = true;
		};
  };

  services.xserver.displayManager = {
    sessionPackages = [ pkgs.gnome.gnome-session.sessions ];
  };

  services.xserver.desktopManager.gnome.enable = true;
	services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

	programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}";

  xdg.portal = {
    #extraPortals = [ pkgs.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
    wlr.enable = true;
    enable = true;
  };

	programs.gnupg.agent = {
	  enable = true;
	  enableSSHSupport = true;
		pinentryPackage = pkgs.pinentry-qt;
	};  

	services.fwupd.package =
    (import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
        sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
      })
      {
        inherit (pkgs) system;
      }).fwupd;

  programs.light.enable = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.tlp.enable = true;
  services.blueman.enable = true;
	services.fstrim.enable = true;

  security.protectKernelImage = false;

  environment.systemPackages = with pkgs; [
		yubikey-personalization
		tmux
		zellij
		chromium
		gnome.gnome-settings-daemon
		unstable.anytype
		kdePackages.ksshaskpass
		python312Packages.python-lsp-server
		hyprland
		fira
		nerdfonts
		logisim-evolution
		pinentry-qt
		mealie
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      brightnessctl
			rocm-opencl-icd
    ];
  };

  fonts.packages = with pkgs; [
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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.power-profiles-daemon.enable = lib.mkForce false;

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

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chgrp input /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';
	
	services.udev.packages = with pkgs; [ 
		gnome.gnome-settings-daemon 
		yubikey-personalization
	];

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

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
 
  services.kanata = {
    enable = true;
    keyboards.default.devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
    keyboards.default = {
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
}
