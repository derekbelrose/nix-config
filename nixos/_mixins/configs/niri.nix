{
pkgs,
...
}:
{
  programs.niri.enable = true;
  environment.systemPackages = [
    pkgs.xdg-desktop-portal-gnome
  ];   
}
