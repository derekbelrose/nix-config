{ inputs, pkgs, ... }:
{
	containers.test1 = {
		bindMounts = {
			"/etc/ssh/ssh_host_ed25519_key" = {
				isReadOnly = true;
			};	
		};

		autoStart = true;
		privateNetwork = true;
		hostBridge = "br0";
		enableTun = true;
		additionalCapabilities = [
			"CAP_NET_ADMIN"
		];

		config = { config, lib, pkgs, ... }:{
			imports = [ inputs.sops-nix.nixosModules.sops ];

			sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

			sops.secrets."tailscale_auth" = {
				sopsFile = ../../../../secrets/tailscale.enc.secret;
				format = "binary";
			};

			boot.isContainer = true;
			networking = {
				useDHCP = lib.mkForce true;
				firewall.enable = false;
				useHostResolvConf = lib.mkForce false;
			};
	
			services.tailscale = {
				enable = true;
				package = pkgs.tailscale;
				authKeyFile = config.sops.secrets."tailscale_auth".path;
			};
		};	
	};
}
