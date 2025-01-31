{ lib, pkgs, config, options, ... }:

{
 	services.displayManager.sessionPackages = [
		pkgs.sway
	];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      unstable.corrupter
      swaylock
      swayidle
      wl-clipboard
      wf-recorder
      slurp
      alacritty
      rofi-wayland
      wofi
			dbus
      grim
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

