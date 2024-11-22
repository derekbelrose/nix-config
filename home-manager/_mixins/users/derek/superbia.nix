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
