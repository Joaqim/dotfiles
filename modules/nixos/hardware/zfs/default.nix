{
  config,
  lib,
  ...
}:
let
  cfg = config.my.hardware.zfs;
in
{
  options.my.hardware.zfs = with lib; {
    enable = mkEnableOption "zfs module for docker virtualization for storage and enable trim and scrub";

    zfsDataset = mkOption {
      type = types.str;
      example = "zpool/local";
      description = "The dataset to use for docker virtualization zfs.";
    };

    autoScrub = my.mkDisableOption "Enable auto scrub for zfs.";
    trim = my.mkDisableOption "Enable trim for zfs.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        extraOptions = "--storage-opt=zfs.fsname=${cfg.zfsDataset}";
        storageDriver = "zfs";
      };
    };

    services.zfs = {
      autoScrub.enable = cfg.autoScrub;
      trim.enable = cfg.trim;
    };
  };
}
