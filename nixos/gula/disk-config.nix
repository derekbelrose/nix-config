{ config, ... }:{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
	# /dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686A66902
        device = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686A66902";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00"; 
              label = "BOOT";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            root = {
              size = "100%";
              label = "root";

              content = {
                type = "btrfs";
                extraArgs = [
                  "-L ${config.host.name}"
                  "-O bgt"
                  "-f"
                ];

                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd"];
                  };

                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd"];
                  };

                  "@var" = {
                    mountpoint = "/var";
                    mountOptions = ["compress=zstd"];
                  };

                  "@nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

