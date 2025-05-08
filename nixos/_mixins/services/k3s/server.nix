{ hostname 
, config
, pkgs
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
		sopsFile = ./k3s.yaml.enc;
		format = "yaml";
	};
	
  services.k3s = {
    enable = true;
    role = "server";
		tokenFile = config.sops.secrets.k3s-token.path;
    extraFlags = [];
    clusterInit = true;
  };

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.openiscsi
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi:${hostname}";
  };

  # Fix for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
}
