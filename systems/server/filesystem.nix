{
  imports = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d19c9a45-df20-4d7f-a225-5d304c51339e";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C526-8C91";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  services.udisks2.enable = true;
}
