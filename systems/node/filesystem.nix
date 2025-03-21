{
  imports = [];

  fileSystems = {
    "/" = {
      device = "zroot/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FE23-1495";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/nix" = {
      device = "zroot/local/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/persist" = {
      device = "zroot/local/persist";
      fsType = "zfs";
      neededForBoot = true;
      options = ["zfsutil"];
    };

    "/tmp" = {
      device = "zroot/local/tmp";
      fsType = "zfs";
      options = ["zfsutil"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-partuuid/3e287139-bf07-483f-a692-18e8e28e0aae";}
  ];

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zroot/local";
      storageDriver = "zfs";
    };
  };

  services = {
    udisks2.enable = true;

    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
  };
}
