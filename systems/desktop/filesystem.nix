{
  imports = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/07b9fd6b-7627-4d61-b1b5-a56d52bdacb4";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/DBA6-FD9D";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/home/jq/Drives/Games" = {
      device = "/dev/disk/by-label/Games";
      fsType = "ext4";
      options = [
        "rw"
      ];
    };
#    "/home/jq/Drives/Storage" = {
#      device = "/dev/disk/by-label/Storage";
#      fsType = "ext4";
#      options = [
#        "rw"
#      ];
#   };
    "/home/jq/Drives/Synology/jq" = {
      device = "//10.0.0.122/homes/jq";
      fsType = "cifs";
      options = [
        "credentials=/etc/cifs"
        "rw"
        "uid=1000"
        "gid=100"
      ];
    };
    "/home/jq/Drives/Synology/Garnet" = {
      device = "//10.0.0.122/homes/Garnet";
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

  system.activationScripts.setPermissions = ''
 #  chown -R jq:wheel /home/jq/Drives/Storage
 #  chmod -R 700 /home/jq/Drives/Storage
    chown -R jq:wheel /home/jq/Drives/Games
    chmod -R 700 /home/jq/Drives/Games
  '';

  services.udisks2.enable = true;
}
