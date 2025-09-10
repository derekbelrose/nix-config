{ outputs
, inputs
, config
, lib
, pkgs
, username
, modulesPath
, home-manager
, ...
}:
let 
   dbus-sway-environment = pkgs.writeTextFile {
     name = "dbus-sway-environment";
     destination = "/bin/dbus-sway-environment";
     executable = true;
 
     text = ''
       dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal
 -wlr
       systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-port
 al-wlr
     '';
   };

  boot.extraModprobeConfig = "options kvm_intel nested=1";
   boot.kernelParams = [
    "quiet"
    "splash"
    "amdgpu.ppfeaturemask=0xffffffff"
   ];

  gaming = with pkgs; [
    # steam - now managed by programs.steam
    steam-run
    moonlight-qt
    sunshine
    adwaita-icon-theme
    lutris
    playonlinux
    wineWowPackages.staging
    winetricks
    vulkan-tools
    steamtinkerlaunch
    mangohud
  ];
in
 {
    hardware.system76.enableAll = true;
    programs.niri.enable = true;
    networking.nftables.enable = true;
    
    time.timeZone = "America/New_York";
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../_mixins/configs/sway.nix
        ../_mixins/configs/client.nix
        ./hardware-configuration.nix
        #../_mixins/configs/hyprland.nix
        #../_mixins/services/open-webui.nix
        #../_mixins/configs/ollama.nix
        #../_mixins/configs/niri.nix
        #../_mixins/configs/cosmic.nix
        #../_mixins/services/kubernetes/master.nix
    ];

    nix.settings.experimental-features = [ "flakes" "nix-command" ];
  
    systemd.services.syncthing = {
      environment = {
        STNODEFAULTFOLDER = "false";
      };
    };

    #services.networking.websockify = {
    #  enable = true;
    #  #sslCert = "/https-cert.pem";
    #  #sslKey = "/https-key.pem";
    #  portMap = {
    #    "5959" = 5900;
    #  };
    #};

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot = {
        loader.systemd-boot.enable = true;
        loader.systemd-boot.consoleMode = lib.mkForce "auto";
        loader.efi.canTouchEfiVariables = true;
        initrd.kernelModules = [ "amdgpu" "kvm-intel" ];
        kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    };
    
    networking = {
        hostId = "b7527247";
        #nat.enable = true;
        #nat.internalInterfaces = ["ve-+"];
        #nat.externalInterface = "enp6s0";
        #nftables.enable = true;
        
        #extraHosts = "100.105.177.118 bitwarden.belrose.io";
    };

    nixpkgs.overlays = [
        #inputs.niri.overlays.niri 
        outputs.overlays.additions
    ];
    nixpkgs.config.allowUnfree = true;

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    }; 

    services = {
        # Enable CUPS to print documents.
        printing.enable = true;

        # Enable Avahi
        avahi = {
          nssmdns4 = true;
          enable = true;
          ipv4 = true;
          ipv6 = true;
          publish = {
          	enable = true;
          	addresses = true;
          	workstation = true;
          };
        };

       fwupd = {
           enable = true;
           extraRemotes = [ "lvfs-testing" ];
       };

       tailscale.enable = true;
       pipewire = {
           enable = true;
           alsa.enable = true;
           alsa.support32Bit = true;
           pulse.enable = true;
           jack.enable = true;
       };
       dbus.enable = true;
       upower.enable = lib.mkForce false;
  
       desktopManager.plasma6.enable = true;

      udev.packages = [ pkgs.brightnessctl ];
      udisks2.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      blueman.enable = true;

      davfs2.enable = true;
      gnome.gnome-keyring.enable = true;

      atuin = {
        enable = true;
      };

      fstrim.enable = true;
    };

    #Set your time zone.
    
    #Enable the X11 windowing system.
    
    #Enable the Plasma Desktop Environment.
    #services.xserver.desktopManager.plasma5.enable = false;
    #services.xserver.desktopManager.gnome.enable = true;
    
    #services.xserver.displayManager.gdm = {
    #  enable = lib.mkForce false;
    #  wayland = false;
    #};
    
    services.xserver.displayManager.gdm = {
      enable = lib.mkForce true;
    };

    services.xserver.displayManager.lightdm = {
      enable = lib.mkForce false;
    };
    
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];
    };
    
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    
    programs.gamemode.enable = true;

    #nixpkgs.overlays = [ 
    #  (import (builtins.fetchTarball {
    #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    #  }))
    #];
    
    services.pulseaudio.enable = false;
    hardware.keyboard.zsa.enable = true;
    hardware.enableAllFirmware = true;
    
    environment.variables.LIBVA_DRIVER_NAME="iHD";
      
    environment.sessionVariables = rec {
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_CACHE_HOME = "$HOME/.cache";
        
        XDG_BIN_HOME = "$HOME/.local/bin";
        PATH = [
        	"${XDG_BIN_HOME}"
        ];

        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        # Atuin environment variables
        ATUIN_SESSION = "";
        # Cursor theme for consistency across apps
        XCURSOR_THEME = "Bibata-Modern-Ice";
    };

    services.emacs = {
        enable = true;
        package = pkgs.emacs30-pgtk;
    };
    
    
    # Enable sound.
    #sound.enable = true;
    
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.derek = {
      isNormalUser = true;
      extraGroups = [ "incus-admin" "wheel" "dialout" "networkmanager" "video" "render" "dialout" "uinput" "libvirtd" ]; 
      packages = with pkgs; [
      ];
    };
    
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [ (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd];
          };
        };
      };
      docker = {
        enable = true;
        storageDriver = "btrfs";
        rootless = {
          enable = false;
          setSocketVariable = true;
        };
      };

      waydroid.enable = false;
    
      podman = {
        enable = false;
        dockerCompat = false;
        defaultNetwork.settings.dns_enabled = true;
      };
  
      incus.enable = true;
    };
    
    environment.systemPackages = with pkgs; [
        virt-manager
        clinfo
        nix-direnv
        xwayland-satellite
        swaylock
        swayidle
        unstable.exo
        oterm
        amdvlk
        vulkan-tools
        glxinfo
        #devenv
        cliphist
        pavucontrol
        waypipe
        unstable.minigalaxy
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #distrobox
        wget
        wayland
        xdg-utils # for opening default programs when clicking links
        glib # gsettings
        dracula-theme # gtk theme
        adwaita-icon-theme  # default gnome cursors
        jq
        redshift
        psmisc
        pavucontrol
        playerctl
        trash-cli
        git
        #xdg-desktop-portal
        go
        gotools
        bitwarden
        bitwarden-cli
        wally-cli
        qutebrowser
        btop
        sof-firmware
        tmux
        flatpak
        bottles
        just
        chromium
        wally-cli
        wayland-utils
        orca-slicer
        lact
        #comfyuiPackages.comfyui
        unstable.nixos-rebuild-ng
        inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
    ]++ gaming;
    
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
        powerline-fonts
        #nerdfonts
    ]; #++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
     programs.mtr.enable = true;
    
    programs.gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
    };
    
    programs.mosh.enable = true;
    
    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
        ];
    };
  
    #systemd.services.lact = {
    #  description = "AMDGPU Control Daemon";
    #  after = ["multi-user.target"];
    #  wantedBy = ["multi-user.target"];
    #  serviceConfig = {
    #    ExecStart = "${pkgs.lact}/bin/lact daemon";
    #  };
    #  enable = true;
    #};
 
    programs.dconf.enable = true;
    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    services.devmon.enable = true;

    services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ]; 
    };

    hardware.graphics = {
        enable = true;
        #driSupport = true;
        enable32Bit = lib.mkDefault true;
        extraPackages = with pkgs; [
            glxinfo
            mesa
            vulkan-tools
            vaapiVdpau
            libva-utils
            libvdpau-va-gl
            rocmPackages.clr.icd
        ];	
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [ "--expose-wayland" ];
    };

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;

    nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
        steam = pkgs.steam.override {
            extraPkgs = pkgs: with pkgs; [
              gamescope
            ];
        };
    };


   # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 8080 11434 2234 ];
   # networking.firewall.allowedUDPPorts = [ ... ];
   # Or disable the firewall altogether.
   # networking.firewall.enable = false;
   
   # Copy the NixOS configuration file and link it from the resulting system
   # (/run/current-system/configuration.nix). This is useful in case you
   # accidentally delete configuration.nix.
   system.copySystemConfiguration = false;


   # This value determines the NixOS release from which the default
   # settings for stateful data, like file locations and database versions
   # on your system were taken. It's perfectly fine and recommended to leave
   # this value at the release version of the first install of this system.
   # Before changing this value read the documentation for this option
   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

   systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
   ];

  environment.etc."lact/config.yaml".text =
    let
      gpuConfig = # yaml
        ''
          fan_control_enabled: true
          fan_control_settings:
            mode: curve
            static_speed: 0.5
            temperature_key: edge
            interval_ms: 500
            curve:
              60: 0.0
              70: 0.5
              75: 0.6
              80: 0.65
              90: 0.75
          pmfw_options:
            acoustic_limit: 3300
            acoustic_target: 2000
            minimum_pwm: 15
            target_temperature: 80
          # Run at 257 for slightly better performance but louder fans
          power_cap: 231.0
          performance_level: manual
          max_core_clock: 2394
          voltage_offset: -30
          power_profile_mode_index: 0
          power_states:
            memory_clock:
            - 0
            - 1
            - 2
            - 3
            core_clock:
            - 0
            - 1
            - 2
        '';
    in
    # yaml
    ''
      daemon:
        log_level: info
        admin_groups:
        - wheel
        - sudo
        disable_clocks_cleanup: false
      apply_settings_timer: 5
    '';

  #systemd.services.fix-nix-dirs = let
  #  profileDir = "/nix/var/nix/profiles/per-user/${username}";
  #  gcrootsDir = "/nix/var/nix/gcroots/per-user/${username}";
  #in {
  #  script = ''
  #    #!${pkgs.stdenv.shell}
  #    set -euo pipefail

  #    mkdir -p ${profileDir} ${gcrootsDir}
  #    chown ${username}:root ${profileDir} ${gcrootsDir}
  #  '';
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #  };
  #};
  
  #containers.ibm = 
  #let 
  #  hostCfg = config;
  #  userName = "derek";
  #  userUid = 1000;
  #in {
  #  allowedDevices = [
  #    { modifier = "rwm";
  #      node = "/dev/dri/renderD129";
  #    }
  #  ];
  #  ephemeral = true;
  #  bindMounts = {
  #    waylandDisplay = rec {
  #      hostPath = "/run/user/${toString userUid}";
  #      mountPoint = hostPath;
  #      isReadOnly = false;
  #    };
  #    x11Display = rec {
  #      hostPath = "/tmp/.X11-unix";
  #      mountPoint = hostPath;
  #      isReadOnly = true;
  #    };
  #    "/home/derek" = {
  #      hostPath = "/home/derek/containers/ibm/home";
  #      isReadOnly = false;
  #    }; 
  #    "/dev/dri" = {
  #      hostPath = "/dev/dri";
  #      isReadOnly = false;
  #    };
  #  };
  #  autoStart = false;
  #  privateNetwork = true;
  #  hostAddress = "10.100.0.1";
  #  localAddress = "10.100.0.2";
  #  config = { config, pkgs, lib, ... }: {
  #    users.users.derek = {
  #      extraGroups = [ "wheel" "render" ];
  #      uid = 1000;
  #      isNormalUser = true; 
  #    };
  #    security.polkit.adminIdentities = [ "unix-user:derek" "unix-group:admin" ];
  #    services.desktopManager.plasma6.enable = true;
  #    xdg.portal.enable = true;
  #    xdg.portal.extraPortals =  [ pkgs.xdg-desktop-portal-gtk ];
  #    services.flatpak.enable = true;
  #    environment.systemPackages = with pkgs; [
  #      vim
  #      firefox
  #      ungoogled-chromium
  #      emacs-gtk
  #      alacritty
  #      vscodium
  #      zed-editor
  #      devenv
  #    ];

  #    hardware.opengl = {
  #      enable = true;
  #      extraPackages = hostCfg.hardware.opengl.extraPackages;
  #    };
  #
      system.stateVersion = lib.mkForce "25.05";

  #    nix = {
  #      # This will add each flake input as a registry
  #      # To make nix3 commands consistent with your flake
  #      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  #
  #      # This will additionally add your inputs to the system's legacy channels
  #      # Making legacy nix commands consistent as well, awesome!
  #      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  #      
  #      optimise.automatic = true;

  #      settings = {
  #        auto-optimise-store = true;
  #        experimental-features = [ "nix-command" "flakes" ];
  #        warn-dirty = false;
  #        trusted-users = [ "derek" ];
  #        #download-buffer-size = 134217728;
  #      
  #        trusted-public-keys = [
  #          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  #          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
  #        ];
  #        substituters = [
  #          "https://cache.nixos.org"
  #          "https://nixpkgs-wayland.cachix.org"
  #          "https://nix-community.cachix.org"
  #          "https://cosmic.cachix.org/" 
  #        ];
  #      };
  #    };
  #    networking = {
  #      firewall = {
  #        enable = true;
  #        allowedTCPPorts =  []; 

  #      };

  #      useHostResolvConf = lib.mkForce false;
  #    };

  #    services.resolved.enable = true;
  #  }; 
  #};
  
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
  systemd.services.lactd.enable = true;

	programs.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
	};

	#services.displayManager = {
	#	autoLogin.enable = true;
	#	autoLogin.user = "derek";
	#};

	#services.greetd = {
  #  enable = true;
  #  settings = rec {
  #    initial_session = {
  #      command = "Hyprland";
  #      user = "derek";
  #    };
  #    default_session = initial_session;
  #  };
  #};

  # Prefer Hyprland XDG portal
  #xdg.portal = {
  #  enable = true;
  #  xdgOpenUsePortal = true;
  #  # Hyprland module provides its own portal; include only GTK here to avoid duplicate units
  #  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #  config = {
  #    common = {
  #      default = [ "hyprland" "gtk" ];
  #      "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
  #    };
  #  };
  #};

  # Make Qt apps follow GNOME/GTK settings for closer match to GTK theme
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
    pam.services = {
      #login.kwallet.enable = true;
      #gdm.kwallet.enable = true;
      #gdm-password.kwallet.enable = true;
      hyprlock = { };
      # Unlock GNOME Keyring on login for GVFS credentials
      #login.enableGnomeKeyring = true;
      #gdm-password.enableGnomeKeyring = true;
    };
  };

  # Auto Tune
  #services.bpftune.enable = true;
  #programs.bcc.enable = true;

  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
}


