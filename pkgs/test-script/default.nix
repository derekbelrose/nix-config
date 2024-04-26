let 
	nixpkgs = import <nixpkgs> {};
	allpkgs = nixpkgs // pkgs;
	pkgs = with nixpkgs; {
		hello = pkgs.callPackage ./hello.nix { audience = "people"; };
	};
in
pkgs
