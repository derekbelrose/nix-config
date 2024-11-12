{ outputs
, inputs
, config
, lib
, pkgs
, modulesPath
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

   hardware.system76.enableAll = true;

   configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
    }; 
in
 {
    time.timeZone = "America/New_York";
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../../modules/suspend-then-hibernate.nix
        ../_mixins/configs/sway.nix
        ../_mixins/configs/client.nix
        ./hardware-configuration.nix
        inputs.nixos-cosmic.nixosModules.default
        ../_mixins/configs/hyprland.nix
        #../_mixins/configs/ollama.nix
        #../_mixins/configs/cosmic.nix
    ];

    nix.settings.experimental-features = [ "flakes" "nix-command" ];

    services.displayManager.sddm = {
      enable = true;
      wayland.compositor = "kwin";
      wayland.enable = true;
    };

    #services.xserver.displayManager.lightdm = {
    #  enable = true;
    #  greeters = {
    #    slick.enable = true;
    #    #enso.enable = true;
    #  };
    #};

    # Use the systemd-boot EFI boot loader.
    boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        kernelModules = [ "kvm-intel" ];
    };
    
    networking = {
        hostId = "b7527247";
        nat.enable = true;
        nat.internalInterfaces = ["ve-+"];
        nat.externalInterface = "enp6s0";
        
        #extraHosts = "100.105.177.118 bitwarden.belrose.io";
    };

    nixpkgs.overlays = [
        outputs.overlays.additions
    ];
    nixpkgs.config.allowUnfree = true;

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
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

      ollama = {
        acceleration = "rocm";
        enable = true;
        environmentVariables = {
          ROC_ENABLE_PRE_VEGA = "1";
          HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        };
      };
    };

#    services.udev.extraRules = ''
#      SUBSYSTEM="tty",ATTRS{idProduct}=="ea60",ATTRS{idVendor}=="10c4",GROUP="plugdev",TAG+="uaccess"
#    '';
    services.xserver.enable = true;

    #Set your time zone.
    
    #Enable the X11 windowing system.
    
    #Enable the Plasma Desktop Environment.
    #services.xserver.desktopManager.plasma5.enable = false;
    #services.xserver.desktopManager.gnome.enable = true;
    
    services.xserver.displayManager.gdm = {
      enable = lib.mkForce false;
      wayland = false;
    };
    
    
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      #extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    
    programs.gamemode.enable = true;
   
    
    #nixpkgs.overlays = [ 
    #  (import (builtins.fetchTarball {
    #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    #  }))
    #];
    
    hardware.pulseaudio.enable = false;
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
    };

       
    
    programs.waybar.enable = true;
    
    services.emacs = {
        enable = true;
        package = pkgs.emacs29-pgtk;
    };
    
    
    # Enable sound.
    sound.enable = true;
    
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.derek = {
      isNormalUser = true;
      extraGroups = [ "wheel" "dialout" "networkmanager" "video" "render" "dialout" "uinput" ]; 
      packages = with pkgs; [
      ];
    };
    
    virtualisation = {
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
    };
    
    environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        distrobox
        wget
        firefox
        configure-gtk
        wayland
        xdg-utils # for opening default programs when clicking links
        glib # gsettings
        dracula-theme # gtk theme
        gnome3.adwaita-icon-theme  # default gnome cursors
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
        ollama
        flatpak
        bottles
        just
        chromium
        wally-cli
        glxinfo
        libva-utils
        mesa
        mesa_drivers
        vulkan-tools
        wayland-utils
        unstable.orca-slicer
    ];
    
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
    
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
     programs.mtr.enable = true;
    
    programs.gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
       #pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    };
    
    programs.mosh.enable = true;
    
    programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
        ];
    };
 
    programs.dconf.enable = true;
    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ]; 
    };

    hardware.opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
            vaapiIntel
            vaapiVdpau
            libvdpau-va-gl
            intel-gpu-tools
            amdvlk
        ];	
        extraPackages32 = with pkgs; [
          driversi686Linux.amdvlk
        ];
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

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



    security.rtkit.enable = true;
    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
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
}

