# https://github.com/Mic92/dotfiles/blob/main/nixos/turingmachine/modules/disko.nix
{
  disko.devices = {
    disk = {
      "kingston240" = {
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
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
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
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
        options.ashift = "12";
        datasets = {
          "local" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
            };
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
            postCreateHook = "zfs snapshot zroot/local/root@blank";
          };
          "local/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options.sync = "disabled";
          };
          "local/win10" = {
            type = "zfs_fs";
            mountpoint = "/mnt/win10";
            options.sync = "disabled";
          };
        };
      };
    };
  };
}
