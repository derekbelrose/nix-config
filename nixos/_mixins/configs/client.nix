{ lib
, hostname
, pkgs
, ...
}: 
let 
	isInstall =
		if (builtins.substring 0 4 hostname != "iso-")
		then true
		else false;
in
{

	services.xserver.enable = true;
	services.desktopManager.plasma6.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	xdg.portal.enable = true;
	xdg.portal.configPackages = [
		pkgs.gnome.gnome-session
	];
	xdg.portal.extraPortals = with pkgs;[
		xdg-desktop-portal-kde
	];

  services.flatpak = lib.mkIf (isInstall) {
		enable = true;
  };

	programs.ssh.askPassword = lib.mkForce("ksshAskPass");

  systemd.services = {
     configure-flathub-repo = lib.mkIf (isInstall) {
       wantedBy = ["multi-user.target"];
       after = [ "network-online.target" ];
       wants = [ "network-online.target" ];
       path = [ pkgs.flatpak ];
       script = ''
         sleep 10 && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
       '';
     };
  };

	environment.systemPackages = with pkgs; [
		vim
		kitty
		alacritty
	];
  
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
} 
