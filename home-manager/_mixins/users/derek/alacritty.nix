{ ... }: {
  programs.alacritty = {
  	enable = true;
  	settings = {
  		cursor.style = {
  			shape = "beam";
  			blinking = "on";
  		};
  		font = {
  			size = 12;
  			normal = {
  				family = "FiraMono Nerd Font"; 
  				style = "Regular";
  			};
  			bold = {
  				family = "FiraMono Nerd Font";
  				style = "Bold";
  			};
  			italic = {
  				family = "FiraMono Nerd Font";
  				style = "Italic";
  			};
  		};
  		colors = {
  			primary = {
  				background = "0x2D0D16";
  				foreground = "0xf8f8f0";
  			};
  			normal = {
  				black = "0x464258";
  				red = "0xff857f";
  				green = "0xad5877";
  				yellow = "0xe6c000";
  				blue = "0x6c71c4";
  				magenta = "0xb267e6";
  				cyan = "0xafecad";
  				white = "0xcccccc";
  			};
  			bright = {
  				black = "0xc19fd8";
  				red = "0xf44747";
  				green = "0xffb8d1";
  				yellow = "0xffea00";
  				blue = "0x6796e6";
  				magenta = "0xc5a3ff";
  				cyan = "0xb2ffdd";
  				white = "0xf8f8f0";
  			};
  		};
  	};
  };
}
