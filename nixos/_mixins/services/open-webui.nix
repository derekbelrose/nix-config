{ pkgs
, config
, ...
}:{
	networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ config.services.open-webui.port ];
	services.open-webui = {
		enable = true;
    package = pkgs.unstable.open-webui;
    openFirewall = true;
    host = "0.0.0.0";
    environment = {
      OLLAMA_BASE_URL = "http://localhost:11434";
      OLLAMA_API_BASE_URL = "http://localhost:11434";
    };
	};
} 
