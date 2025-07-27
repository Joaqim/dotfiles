{
  config,
  lib,
  modulesPath,
  ...
}:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  my.hardware = {
    firmware = {
      cpuFlavor = "intel";
      kernelOptimization = true;
    };

    graphics = {
      enable = true;
      gpuFlavor = "nvidia";
      nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };
    sound = {
      pipewire.enable = true;
    };
    # Use zfs specific settings for docker virtualization and zfs trim and scrub
    zfs = {
      enable = true;
      zfsDataset = "zpool-${hostName}/local";
    };
  };
}
