{ hostname 
, config
, pkgs
, hostname
, ... 
}:
{
#	networking.firewall.allowedTCPPorts = [
#		6443
#		2379
#		2380
#	];	

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
    role = "agent";
		tokenFile = config.sops.secrets.k3s-token.path;
    serverAddr = "https://gula:6443";
    extraFlags = toString ([
    ]);
  };

  environment.systemPackages = [
    pkgs.kubectl
    pkgs.openiscsi
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi:${hostname}";
  };

  # fix for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
}
