{ 
  pkgs
, ...
}: 
let

in
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "Paradise";
        "server string" = "Paradise File Server";
        "netbios name" = "Paradise";
        "security" = "user";
        "hosts allow" = "172.16.0 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      "backups" = {
        "path" = "/store/backups";
        "browseable"  = "yes";
        "read only" = "no"; 
        "guest ok" = "no";
        "create mask" = "0750";
        "force user" = "derek";
        "force group" = "files";
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
