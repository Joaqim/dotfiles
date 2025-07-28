{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
in
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import zroot-${hostName} ; zfs rollback -r zroot-${hostName}/local/root@blank
  '';
}
