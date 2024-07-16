{
  imports = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/545afff3-28fd-4407-a847-d6bce632dab0";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6AE6-7B89";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/home/jq/Drives/Synology" = {
      device = "//10.0.0.122/homes/jq";
      fsType = "cifs";
      options = [
        "credentials=/etc/cifs"
        "rw"
        "uid=1000"
        "gid=100"
      ];
    };
    "/home/garnet/.local/share/PrismLauncher/instances/1.21/.minecraft/saves" = {
      device = "//10.0.0.122/homes/Garnet/Minecraft";
      fsType = "cifs";
      options = [
        "credentials=/etc/cifs"
        "rw"
        "uid=1001"
        "gid=100"
      ];
    };
  };
  services.udisks2.enable = true;
}
