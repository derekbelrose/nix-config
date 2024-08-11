{ pkgs, ... }:
{
	services.adguardhome.enable = true;
	services.adguardhome.openFirewall = true;
	services.adguardhome.mutableSettings = true;
}
