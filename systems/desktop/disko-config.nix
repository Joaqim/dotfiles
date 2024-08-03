# https://github.com/Mic92/dotfiles/blob/main/nixos/turingmachine/modules/disko.nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        #device = "/dev/nvme1n1";
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
                mountOptions = ["nofail"];
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
                pool = "zpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      zpool = {
        type = "zpool";
        rootFsOptions = {
          # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          atime = "off";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        options.ashift = "12";
        datasets = {
          "local" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
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
          };
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot zpool/local/root@blank";
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
