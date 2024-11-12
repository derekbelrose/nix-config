{ inputs, ... }: {
  disabledModules = [ "services/x11/desktop-managers/plasma5.nix" ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/x11/desktop-managers/plasma6.nix"
  ];
  
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;

	environment.systemPackages = with pkgs; [
		pinentry-qt
	];
}
