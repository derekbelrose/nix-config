{ inputs, ... }:
{
	additions = final: _prev: import ../pkgs { pkgs = final; };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
