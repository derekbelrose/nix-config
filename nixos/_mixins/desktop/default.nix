{ desktop, hostname, lib, pkgs, username, ... }:
let
	isInstall = if (builtins.substring 0 4 hostname != "iso-") then true else false;

in 
{
  fonts = {
	  # Enable a basic set of fonts providing several font styles and families and reasonable coverage of Unicode.
	  enableDefaultPackages = false;
	  fontDir.enable = true;
	  packages = with pkgs; [
	    #(nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
	    fira
        fira-code-symbols-only
	    liberation_ttf
	    noto-fonts-emoji
	    source-serif
	    twitter-color-emoji
	    work-sans
	  ] ++ lib.optionals (isInstall) [
	    ubuntu_font_family
	  ];

    fontconfig = {
      antialias = true;
      cache32Bit = isGamestation;
      defaultFonts = {
        serif = [ "Source Serif" ];
        sansSerif = [ "Work Sans" "Fira Sans" ];
        monospace = [ "FiraCode Nerd Font Mono" "Symbols Nerd Font Mono" ];
        emoji = [ "Noto Color Emoji" "Twitter Color Emoji" ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = isGamestation;
    };
    openrazer = lib.mkIf (hasRazerPeripherals) {
      enable = true;
      devicesOffOnScreensaver = false;
      keyStatistics = true;
      mouseBatteryNotifier = true;
      syncEffectsEnabled = true;
      users = [ "${username}" ];
    };
    pulseaudio.enable = lib.mkForce false;
    sane = lib.mkIf (isInstall) {
      enable = true;
      #extraBackends = with pkgs; [ hplipWithPlugin sane-airscan ];
      extraBackends = with pkgs; [ sane-airscan ];
    };
  };

  services = {
    flatpak = lib.mkIf (isInstall) {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = isGamestation;
      jack.enable = false;
      package = pkgs.unstable.pipewire;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        package = pkgs.unstable.wireplumber;
      };
    };
    printing = lib.mkIf (isInstall) {
      enable = true;
      drivers = with pkgs; [ gutenprint hplip ];
    };
    system-config-printer.enable = isInstall;

    # Provides users with access to all Elgato StreamDecks.
    # https://github.com/muesli/deckmaster
    # https://gitlab.gnome.org/World/boatswain/-/blob/main/README.md#udev-rules
    udev.extraRules = '' '';

    xserver = {
      desktopManager.xterm.enable = false;
      # Disable autoSuspend; my Pantheon session kept auto-suspending
      # - https://discourse.nixos.org/t/why-is-my-new-nixos-install-suspending/19500
      displayManager.gdm.autoSuspend = if (desktop == "pantheon") then true else false;
      excludePackages = [ pkgs.xterm ];
    };
  };
	
	xserver = {
      desktopManager.xterm.enable = false;
      # Disable autoSuspend; my Pantheon session kept auto-suspending
      # - https://discourse.nixos.org/t/why-is-my-new-nixos-install-suspending/19500
      displayManager.gdm.autoSuspend = if (desktop == "pantheon") then true else false;
      excludePackages = [ pkgs.xterm ];
    };
  };


  xdg.portal = {
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    enable = true;
    xdgOpenUsePortal = true;
  };
}
