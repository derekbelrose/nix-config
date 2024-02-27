{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
	(modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "sg" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };

  fileSystems."/swap" = 
    {
      device = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
      options = [ "subvol=swap" "noatime" "nodatacow" "nospace_cache" ];
      fsType = "btrfs";
    };

  swapDevices = [ 
    { 
	device = "/swap/swapfile";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  programs.light.enable = true;

  hardware.opengl = {
   enable = true;
   driSupport = true;
   extraPackages = with pkgs; [
     intel-media-driver
     intel-vaapi-driver
     vaapiVdpau
     libvdpau-va-gl
   ];
  };    

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  networking.hostId = "122c8330";
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "wlp170s0";

  networking.hostName = "framework"; # Define your hostname.
 
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [
	brightnessctl
	(vivaldi.override {
          proprietaryCodecs = true;
          enableWidevine = false;
        })
        vivaldi-ffmpeg-codecs
        widevine-cdm
  ];

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  boot.resumeDevice = "/dev/disk/by-uuid/18694165-78d3-4b43-8866-17026ed0ffa4";
  boot.kernelParams = [ "mem_sleep_default=deep" "resume_offset=6704013" ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.kanata = {
    enable = true;
    keyboards.default.devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
    keyboards.default = {
      extraDefCfg = ''
        process-unmapped-keys yes
      '';

      config = ''
	(defsrc
	  caps a s d f g h j k l
	)

	(deflayer mine
	  lctl a (tap-hold 200 400 s lmeta) (tap-hold 200 400 d lalt) (tap-hold 200 400 f lctl) g h (tap-hold 200 400 j rctl) (tap-hold 200 400 k ralt) (tap-hold 200 400 l rmet) 
        )
      '';
    };
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=2h";
 
  security.protectKernelImage = false;
}
