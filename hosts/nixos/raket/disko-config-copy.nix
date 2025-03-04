# https://github.com/Mic92/dotfiles/blob/main/nixos/turingmachine/modules/disko.nix
let
  hostName = "raket";
in {
  disko.devices = {
    disk = {
      "nvme-1tb-${hostName}" = {
        type = "disk";
        device = "/dev/sdb";
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
                mountOptions = ["nofail" "fmask=0022" "dmask=0022"];
              };
            };
            swap = {
              size = "16G";
              type = "8200";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zpool-${hostName}";
              };
            };
          };
        };
      };
    };
    zpool = {
      "zpool-${hostName}" = {
        type = "zpool";
        rootFsOptions = {
          # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
          acltype = "posixacl";
          canmount = "off";
          compression = "zstd";
          dnodesize = "auto";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        options.ashift = "12";
        datasets = {
          "local" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              #encryption = "aes-256-gcm";
              #keyformat = "passphrase";
              #keylocation = "prompt";
            };
          };
          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            # Used by services.zfs.autoSnapshot options.
            options."com.sun:auto-snapshot" = "true";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.atime = "off";
          };
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot zpool-${hostName}/local/root@blank";
          };
          "local/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options.sync = "disabled";
          };
        };
      };
    };
  };
}
