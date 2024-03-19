{ config, lib, pkgs, modulesPath, ... }:

{
	imports = 
		[ (modulesPath + "./installer/scan/not-detected.nix")
		];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["sg"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
    options = ["subvol=swap" "noatime" "nodatacow" "nospace_cache"];
    fsType = "btrfs";
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];


	networking.useDHCP = lib.mkDefault true;
	
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRistributableFirmware;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

}
