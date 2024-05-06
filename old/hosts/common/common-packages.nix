{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    btop
    coreutils
    devbox
    dua # Modern `du`
    duf # Modern `df`
    htop
  ];
}
