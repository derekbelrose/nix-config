{ ... }: {
  wayland.windowManager.sway = {
    config = {
      input = {
        "1150:32792:Kensington_Expert_Wireless_TB_Mouse" = {
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
