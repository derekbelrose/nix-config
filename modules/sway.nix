{ outputs
, pkgs
, ...
}:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire.socket wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire.socket wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  #configure-gtk = pkgs.writeTextFile {
  #  name = "configure-gtk";
  #  destination = "/bin/configure-gtk";
  #  executable = true;
  #  text =
  #    let
  #      schema = pkgs.gsettings-desktop-schemas;
  #      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  #    in
  #    ''
  #      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
  #      gnome_schema=org.gnome.desktop.interface
  #    '';
  #};
in
{
  services.dbus.enable = true;

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

  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      unstable.corrupter
      waybar
      mpg123
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      grim
      mako
      slurp
      alacritty
      rofi-wayland
      wofi
      bemenu
      termite
      direnv
      eza
      du-dust
      file
      tree
      htop
      pulseaudio
      dbus-sway-environment
      jq
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
}
