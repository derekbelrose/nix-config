{ 
	pkgs, 
	... 
} :
let 
	cacheDir = "/store/service-data/jellyfin/cache/";
	dataDir = "/store/service-data/jellyfin/data";
	configDir = "/store/service-data/jellyfin/config";
in
{
	services = { 
		jellyfin = {
			inherit cacheDir dataDir configDir;
			enable = true;
			package = pkgs.unstable.jellyfin;
			group = "render";
			user = "jellyfin";
		};
		jellyseerr.enable = true;
	};

	systemd = {
		services.jellyfin.serviceConfig = {
  		DeviceAllow = pkgs.lib.mkForce [ 
				"char-drm rw" "char-nvidia-frontend rw" "char-nvidia-uvm rw" 
				"/dev/dri rw"
				"/dev/nvidia0 rw"
				"/dev/nvidiactl rw"
				"/dev/nvidia-caps/* rw"
				"/dev/dri/card0 rw"
				"/dev/dri/card1 rw"
				"/dev/dri/renderD128 rw"
			];
  		PrivateDevices = pkgs.lib.mkForce false;
  		RestrictAddressFamilies = pkgs.lib.mkForce [ "AF_UNIX" "AF_NETLINK" "AF_INET" "AF_INET6" ];
		};
		tmpfiles.rules = [
			"d ${cacheDir} 770 jellyfin render - -"
			"d ${dataDir} 770 jellyfin render - -"
			"d ${configDir} 770 jellyfin render - -"
		];
	};

	environment.systemPackages = with pkgs; [
		unstable.jellyfin-web
		unstable.jellyfin-ffmpeg
		cudatoolkit
	];

	users.users.jellyfin = {
		description = "Jellyfin Service Account";
		name = "jellyfin";
		extraGroups = [ 
			"render"
			"video"
		];
		isSystemUser = true;
	};
}
