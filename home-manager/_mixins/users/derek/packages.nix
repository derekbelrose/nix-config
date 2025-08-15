{ inputs
, config
, lib
, pkgs
, username
, hostname
, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
	home.packages = with pkgs; [
		brightnessctl
    wl-clipboard
		zellij
		wob
		foot
    alacritty
		fractal
		orca-slicer
    yubikey-personalization
    tmux
    zellij
    chromium
    unstable.anytype
    hyprland
    fira
    nerdfonts
    logisim-evolution
    swaynotificationcenter
    yarn
    wayland-utils
    unstable.devenv

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
}
