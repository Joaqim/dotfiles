{
  imports = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4345e204-09e1-4b94-9098-39a28bc91fd7";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C32D-6E6F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/run/media/jq/Jellyfin" = {
      device = "//10.0.0.122/homes/jq/Jellyfin";
      fsType = "cifs";
      options = [
        "credentials=/etc/cifs"
        "rw"
        "uid=1000"
        "gid=100"
      ];
    };
  };

  swapDevices = [];

  services.udisks2.enable = true;
}
