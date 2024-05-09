{ hostname ? "gula", disks ? [ "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B7686A66902" ], ... }:
{
  disko.devices = {
    disk = {
      vdb = {
        type = "disk";
        device = builtins.elemAt disks 0;
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
                  "-f"
                ];

                subvolumes = {
                  "root" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "subvol=root"];
                  };

                  "home" = {
                    mountpoint = "/home";
                    mountOptions = ["compress=zstd" "subvol=home"];
                  };

                  "var" = {
                    mountpoint = "/var";
                    mountOptions = ["compress=zstd" "subvol=var"];
                  };

                  "nix" = {
                    mountOptions = [ "compress=zstd" "noatime" "subvol=nix" ];
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

