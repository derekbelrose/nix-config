{ inputs
, ... }: {
  additions = final: _prev: import ../pkgs { pkgs = final; };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  master-packages = final: _prev: {
		master = import inputs.nixpkgs-master {
			inherit (final) system;
			config.allowUnfree = true;
		};
  };

  modifications = final: prev: {
    #hyprland = prev.hyprland.overrideAttrs ( old: {
    #  pname = "hyprland";
    #  version = "0.41.2-derek";
    #  src = prev.fetchFromGitHub {
    #    owner = "hyprwm";
    #    repo = "hyprland";
    #    fetchSubmodules = true;
    #    rev = "refs/tags/v0.42.0";
    #    hash = "sha256-deu8zvgseDg2gQEnZiCda4TrbA6pleE9iItoZlsoMtE=";
    #  };
    #}); 
  };
}
