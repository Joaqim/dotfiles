{config, ...}: let
  inherit (config.networking) hostName;
in {
  fileSystems."/persist".neededForBoot = true;

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zpool-${hostName}/local";
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
