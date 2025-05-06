{ hostname 
, config
, ... 
}:
{
	networking.firewall.allowedTCPPorts = [
		6443
		2379
		2380
	];	

	networking.firewall.allowedUDPPorts = [
		8472
	];

	sops.secrets.k3s-token = {
		restartUnits = [ "k3s.service" ];
		sopsFile = ./token.yaml.enc;
		format = "yaml";
	};
	
  services.k3s = {
    enable = true;
    role = "server";
		tokenFile = config.sops.secrets.k3s-token.path;
    extraFlags = [];
    clusterInit = true;
  };
}
