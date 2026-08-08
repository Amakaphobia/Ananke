{
  disko.devices = {
    disk.main = {
      type = "disk";

      # Use a stable by-id path, not /dev/nvme0n1.
      device = "/dev/disk/by-id/nvme-eui.8ce38e05011f83aa";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          cryptroot = {
            size = "100%";

            content = {
              type = "luks";
              name = "crypted";
              askPassword = true;

              settings = {

                # Conservative privacy default.
                allowDiscards = false;
              };

              content = {
                type = "lvm_pv";
                vg = "nyx";
              };
            };
          };
        };
      };
    };

    lvm_vg.nyx = {
      type = "lvm_vg";

      lvs = {
        swap = {
          # keep atleast at 30 because of hibernation
          size = "36G";

          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        root = {
          size = "100%";

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];

            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/persist" = {
                mountpoint = "/persist";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
