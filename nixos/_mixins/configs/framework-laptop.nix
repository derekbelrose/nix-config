{
	inputs
, pkgs
, lib
, config
, ...
}:{
	imports = [
		inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
		./laptop.nix
	];

	services.fprintd.enable = true;
	
	security.pam.services.sudo-fingerprint.fprintAuth = true;

	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

	hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.power-profiles-daemon.enable = lib.mkDefault false;

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
  };

  hardware.graphics = {
    enable = true;
    #driSupport = true;
    extraPackages = with pkgs; [
			rocmPackages.clr.icd
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      brightnessctl
      # rocmPackages.opencl.icd
    ];
  };

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
          lctl a (tap-hold 200 400 s lmeta) (tap-hold 200 400 d lalt) (tap-hold 200 400 f
lctl) g h (tap-hold 200 400 j rctl) (tap-hold 200 400 k ralt) (tap-hold 200 400 l rmet)
               )
      '';
    };
  };

	services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chgrp video /s
ys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys
/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chgrp input /sys/cl
ass/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/clas
s/leds/%k/brightness"
  '';
}
