{
  imports = [];

  fileSystems."/" = {
    device = "zpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1C83-F77B";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "zpool/local/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zpool/local/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/tmp" = {
    device = "zpool/local/tmp";
    fsType = "zfs";
  };

  swapDevices = [
    #"/dev/disk/by-partuuid/7b81af9e-ac3f-4759-a533-4b78270b80e4"
  ];

  services.udisks2.enable = true;
}
