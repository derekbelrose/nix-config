{ config, pkgs, ... }:
let
  kubeMasterIP = "100.116.115.111";
  #kubeMasterIP = "100.98.241.70";
  kubeMasterHostname = "gula";
  kubeMasterAPIServerPort = 6443;
in
{
  environment.systemPackages = [
    pkgs.kompose
    pkgs.kubectl
    pkgs.kubernetes
    pkgs.nftables
  ];

  services.kubernetes = {
    enable = true;
    singleNode = true;
    
    etcd = {
      enable = true;
    };

    controlPlane = {
      enable = true;
    };

  };

  services.kubelet = {
    enable = true;
  };

  services.kube-proxy = {
    enable = true;
  };

  networking.calico = {
    enable = true;
    vxlanMode = "vxlan";
    ipPool = "172.16.10.1/25";
  };

  services.docker = {
    enable = true;
  };

  virtualisation.docker = {
      enable = true;
  
      # use nvidia as the default runtime
      enableNvidia = true;
      extraOptions = "--default-runtime=nvidia";
  };
}
