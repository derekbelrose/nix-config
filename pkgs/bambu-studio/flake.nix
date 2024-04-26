{

	outputs = { self, nixpkgs, ... }: {
		overlay = final: prev: { bambu-studio = prev.pkgs.callPackage ./. {}: };

		packages.x86_640-linux.default = let 
			pkgs = import nixpkgs {
				overlays = [ self.overlay ];
				system = "x86_64-linux";
			};
		in pkgs.bambu-studio {
			name = "Bambu Studio - Derek";	
		};
	};
}
