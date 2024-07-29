{
  imports = [];

  fileSystems = {
    "/" = {
      device = "zpool-work/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/home" = {
      device = "zpool-work/local/home";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/nix" = {
      device = "zpool-work/local/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/persist" = {
      device = "zpool-work/local/persist";
      fsType = "zfs";
      neededForBoot = true;
      options = ["zfsutil"];
    };

    "/tmp" = {
      device = "zpool-work/local/tmp";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };

  networking.hostId = "6141ba5d";

  swapDevices = [
    {device = "/dev/disk/by-partuuid/52fc1e5c-4ace-4b40-a9ba-d31fa63f21be";}
  ];

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zpool-work/local";
      storageDriver = "zfs";
    };
  };

  services.udisks2.enable = true;
}
