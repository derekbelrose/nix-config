{ lib, config, pkgs, unstablePkgs, nixos-hardware, ... }:

{
	imports =
		[
			./hardware-configuration.nix
		];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		networking.networkmanager.enable = true;

		users.users.derek = { 		
			isNormalUser = true;
			extraGroups = [ "networkmanager" "wheel" ];
			packages = with pkgs; [
				just
				vim

				unstablePkgs.vscode
			];
		};

#		systemd.services.systemd-udevd.restartIfChanged = false;
#		systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
#		systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
#
#		services.fwupd.enable = true;
#		services.tailscale.enable = true;
#		services.flatpak.enable = true;
#
#		sound.enable = true;
#		hardware.pulseaudio.enable = false;
#		security.rtkit.enable = true;
#		services.pipewire = {
#			enable = true;
#			alsa.enable = true;
#			alsa.support32Bit = true;
#			pulse.enable = true;
#		};
#
#		services.printing.enable = true;
#	
#		services.avahi = {
#			enable = true;
#			nssmdns = true;
#			openFirewall = true;
#		};
#
#		services.xserver.enable = true;
#
#		services.xserver.desktopManager.plasma6.enable = true;
#		services.xserver.displayManager.gdm.enable = true;
#		services.xserver.displayManager.gdm.wayland = true;
#
#		services.xserver.xkb = {
#			layout = "us";
#			variant = "";
#		};
#
#		virtualisation.libvirtd.enable = true;
#		virtualisation.spiceUSBRedirection.enable = true;
#		virtualisation = {
#			docker = {
#				enable = true;
#				autoPrunt = {
#					enable = true;
#					dates = "weekly";
#				};
#			};
#		};
#
#
#		programs.partition-manager.enable = true;
#		programs.kdeconnect.enable = true;
#
#		programs.steam = {
#			enable = true;
#		};

		system.stateVersion = "23.11";
}
