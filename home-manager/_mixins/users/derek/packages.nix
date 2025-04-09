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
		devenv
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
    gnome.gnome-settings-daemon
    unstable.anytype
    kdePackages.ksshaskpass
    hyprland
    fira
    nerdfonts
    logisim-evolution
    pinentry-qt
    swaynotificationcenter
    yarn
    wayland-utils
		devenv

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
