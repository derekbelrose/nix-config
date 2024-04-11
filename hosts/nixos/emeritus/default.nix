{ config, pkgs, lib, unstablePkgs, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  }; 

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
  nixpkgs.config.allowUnfree = true;
  
  # nixpkgs.overlays = [ #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	  ../../../modules/sway.nix
    ];
  
  hardware.system76.enableAll = true;
  hardware.keyboard.zsa.enable = true;
  hardware.enableAllFirmware = true;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

#  boot.extraModprobeConfig = ''
#   options snd-intel-dspcfg dsp_driver=1
#   options v4l2loopback-dc width=320 height=240
#  '';
#  boot.extraModProbeConfig = ''
#  '';

  #boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "b7527247";
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "enp3s0";

  networking.hostName = "emeritus"; # Define your hostname.
  #networking.extraHosts = "100.105.177.118 bitwarden.belrose.io";

  # Set your time zone.
  time.timeZone = "America/New_York";


  # Enable Avahi
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

  services.fwupd.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = false;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.udev.extraRules = ''
	SUBSYSTEM="usb",ATTRS{idProduct}=="ea60",ATTRS{idVendor}=="10c4",GROUP="plugdev",TAG+="uaccess"
  '';

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.dbus.enable = true;

  services.upower.enable = lib.mkForce false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	gamescopeSession.enable = true;
  };


  # enable sway window manager
#  programs.sway = {
#    enable = true;
#    wrapperFeatures.gtk = true;
#    extraPackages = with pkgs; [
#      swaylock
#      swayidle
#      wl-clipboard
#      wf-recorder
#      grim
#      mako
#      slurp
#      alacritty
#      xdg-desktop-portal
#      rofi-wayland
#      wofi
#      wdisplays
#      bemenu
#      termite
#      dbus-sway-environment
#      direnv
#      eza
#      bat
#      du-dust
#      file
#      tree
#    ];
#    extraSessionCommands = ''
#      export SDL_VIDEODRIVER=wayland
#      export QT_QPA_PLATFORM=wayland
#      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
#      export JAVA_AWT_WM_NONREPARENTING=1
#      export MOZ_ENABLE_WAYLAND=1
#    '';
#  };

  services.tailscale.enable = true;
  programs.waybar.enable = true;
  
  services.emacs = {
        enable = true;
#        package = pkgs.emacs-pgtk;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.derek = {
    isNormalUser = true;
#    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    extraGroups = [ "wheel" "dialout" "docker" ]; # Enable ‘sudo’ for the user.
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

    podman = {
      enable = false;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  
  environment.systemPackages = with pkgs; [
	unstablePkgs.bambu-studio
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    distrobox
    #orca-slicer
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
    xdg-desktop-portal
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
  # programs.mtr.enable = true;

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

  system.stateVersion = "23.05"; # Did you read the comment?

}

