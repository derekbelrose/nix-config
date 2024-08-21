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
  services.flatpak = lib.mkIf (isInstall) {
		enable = true;
  };

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
		configure-appcenter-repo = lib.mkIf(isInstall) {
			wantedBy = [ "multi-user.target" ];
			path = [ pkgs.flatpak ];
			script = ''
				flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo
			'';
		};
  };

	environment.systemPackages = with pkgs; [
		emacsPackages.emacs
		vulkan-tools
		glxinfo
		opencl-info
		wayland-utils
		clinfo
		kitty
		alacritty
	];
} 
