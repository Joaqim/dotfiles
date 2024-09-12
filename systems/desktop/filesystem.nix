{
  imports = [];

  fileSystems = {
    "/" = {
      device = "zpool/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A8CD-AECE";
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

  networking.hostId = "5b0659ea";
  swapDevices = [
    {device = "/dev/disk/by-partuuid/b2778b43-82b1-42f0-8215-93e4c0c64166";}
  ];

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zpool/local";
      storageDriver = "zfs";
    };
  };

  services = {
    udisks2.enable = true;

    zfs = {
      autoSnapshot.enable = true;
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
