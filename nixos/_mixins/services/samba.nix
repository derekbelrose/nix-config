_: {
	services.samba = {
		enable = true;
		securityType = "user";
		openFirewall = true;
		extraConfig = ''
		  workgroup = WORKGROUP
		  server string = smbnix
		  netbios name = smbnix
		  security = user 
		  #use sendfile = yes
		  #max protocol = smb2
		  # note: localhost is the ipv6 localhost ::1
		  hosts allow = 172.16.0.0/16 127.0.0.1 localhost
		  hosts deny = 0.0.0.0/0
		  guest account = nobody
		  map to guest = bad user
		'';
		shares = {
			isos = {
				path = "/tmp/isos";
		    browseable = "yes";
		    "read only" = "yes";
		    "guest ok" = "yes";
		    "create mask" = "0644";
		    "directory mask" = "0755";
		    "force user" = "derek";
		    "force group" = "users";
			};
		};
	};

	services.samba-wsdd = {
	  enable = true;
	  openFirewall = true;
	};
	
	networking.firewall.enable = true;
	networking.firewall.allowPing = true;
}
