{
  inputs
, config
, lib
, pkgs
, ...}:
let
	modKey = "Mod4";
	ws1 = "1 - Communication";
	ws2 = "2 - Browsing";
	ws3 = "3 - Making";
	ws4 = "4 - Writing";
	ws5 = "5 - Homelab";
	ws6 = "6 - Home Assistant";
	ws7 = "7 - Work";
	ws8 = "8 - Learning";
	ws9 = "9 - More";
	ws10 = "10 - Even more";
in
{
  options.sway.WOBSOCK = lib.mkOption {
    type = lib.types.str;
  };

	config.wayland.windowManager.sway = {
		enable = true;
		checkConfig = true;	
		swaynag = {
			enable = true;
			settings = {};
		};
		systemd = {
			enable = true;
			xdgAutostart = true;
		};
		config = {
			startup = [
				{ command = "sleep 5; swaymsg ${ws1}:"; }
			];
			modifier = modKey;
			terminal = "${pkgs.alacritty}/bin/alacritty";
			gaps = {
				inner = 5;
				outer = 3;
			};
			window.titlebar = false;
			
			keybindings = let
				inherit (config.wayland.windowManager.sway.config) modifier terminal;
			in lib.mkAfter {
				# Exit Sway
				"${modKey}+Shift+Control+q" = "exit";
				# Move Between Workspaces
				"${modKey}+1" = "workspace ${ws1}";
				"${modKey}+2" = "workspace ${ws2}";
				"${modKey}+3" = "workspace ${ws3}";
				"${modKey}+4" = "workspace ${ws4}";
				"${modKey}+5" = "workspace ${ws5}";
				"${modKey}+6" = "workspace ${ws6}";
				"${modKey}+7" = "workspace ${ws7}";
				"${modKey}+8" = "workspace ${ws8}";
				"${modKey}+9" = "workspace ${ws9}";
				"${modKey}+0" = "workspace ${ws10}";

        # Move Active Container to a specific workspaces
				"${modKey}+Shift+1" = "move container to workspace ${ws1}";
				"${modKey}+Shift+2" = "move container to workspace ${ws2}";
				"${modKey}+Shift+3" = "move container to workspace ${ws3}";
				"${modKey}+Shift+4" = "move container to workspace ${ws4}";
				"${modKey}+Shift+5" = "move container to workspace ${ws5}";
				"${modKey}+Shift+6" = "move container to workspace ${ws6}";
				"${modKey}+Shift+7" = "move container to workspace ${ws7}";
				"${modKey}+Shift+8" = "move container to workspace ${ws8}";
				"${modKey}+Shift+9" = "move container to workspace ${ws9}";
				"${modKey}+Shift+0" = "move container to workspace ${ws10}";


				# Move Focus
				"${modKey}+left" = "focus left";
				"${modKey}+Right" = "focus right";
				"${modKey}+Up" = "focus up";
				"${modKey}+Down" = "focus down";

				#Move focused window
				"${modKey}+Shift+Left" = "move left";
				"${modKey}+Shift+Right" = "move right";
				"${modKey}+Shift+Up" = "move up";
				"${modKey}+Shift+Down" = "move down";

				# Shortcuts
				"${modKey}+Return" = "exec ${terminal}";  
        "${modKey}+D" = "exec fuzzel";
				"${modKey}+Shift+q" = "kill";
				"${modKey}+Shift+c" = "reload";
				"${modKey}+b" = "splith";
				"${modKey}+v" = "splitv";

				# Switch current container to different layouts
				"${modKey}+s" = "stacking";
				"${modKey}+w" = "tabbed";
				"${modKey}+e" = "toggle split";
	
				# Fullscreen
				"${modKey}+f" = "fullscreen";

				# Current container toggle floating
				"${modKey}+Shift+space" = "floating toggle";
			
				# Swap focus betweenthe tiling area and the floating area
				"${modKey}+space" = "focus mode_toggle";

				# Move focus to parent container
				"${modKey}+a" = "focus parent";

				# Move the focused window to the scratchpad
				"${modKey}+Shift+minus" = "move scratchpad";

				# Show the next scratchpad window. Cycles if multiple
				"${modKey}+minus" = "scratchpad show";

				# Start applications
				"${modKey}+Shift+b" = "exec ${pkgs.brave}/bin/brave";

				# Emacs client
				"${modKey}+Alt+e" = "exec ${pkgs.emacs}/bin/emacsclient -c";

				# Media Keys
				XF86AudioMute = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle && ${pkgs.pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{printf \"%s\", $5}' > ${config.sway.WOBSOCK}";
				XF86AudioRaiseVolume = "exec ${pkgs.pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ +5%";
  			XF86AudioLowerVolume = "exec ${pkgs.pulseaudio}/bin/pactl  set-sink-volume @DEFAULT_SINK@ -5%";
			};

			workspaceAutoBackAndForth = true;
		};
	};
}
