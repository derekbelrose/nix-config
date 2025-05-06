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
		sopsFile = ./test.yaml.enc;
		format = "yaml";
	};
	
  services.k3s = {
    enable = true;
    role = if hostname == "gula" then "server" else "agent";
		tokenFile = config.sops.secrets.k3s-token.path;
    extraFlags = toString ([
	    "--write-kubeconfig-mode \"0644\""
	    "--disable servicelb"
	    "--disable traefik"
	    "--disable local-storage"
    ] ++ (if hostname == "gula" then [
			"--tls-san 100.116.115.111"
		] else [
	    "--server https://100.116.115.111:6443"
			"--tls-san gula"
    ]));
    clusterInit = (hostname == "gula");
  };
}
