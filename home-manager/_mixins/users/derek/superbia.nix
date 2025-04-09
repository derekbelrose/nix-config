{ ... }: {
  wayland.windowManager.sway = {
    config = {
      input = {
        "*" = {
          left_handed = "disabled";
        };
        "1149:32792:Kensington_Expert_Wireless_TB_Mouse" = {
          left_handed = "enabled";
        }; 
        "1133:49291:Logitech_G502_HERO_Gaming_Mouse" = {
          left_handed = "disabled";
        }; 

      }; 
      output = {
        "*" = {
          res = "3840x2160@60Hz";
          scale = ".9";
        };
      };
    };
  }; 
}
