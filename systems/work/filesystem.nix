{
  imports = [];

  fileSystems = {
    "/" = {
      device = "zpool/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1C83-F77B";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/home" = {
      device = "zpool/local/home";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/nix" = {
      device = "zpool/local/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/persist" = {
      device = "zpool/local/persist";
      fsType = "zfs";
      neededForBoot = true;
      options = ["zfsutil"];
    };

    "/tmp" = {
      device = "zpool/local/tmp";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };

  networking.hostId = "552c25ad";

  swapDevices = [
    {device = "/dev/disk/by-partuuid/7b81af9e-ac3f-4759-a533-4b78270b80e4";}
  ];

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zpool/local";
      storageDriver = "zfs";
    };
  };

  services.udisks2.enable = true;
}
