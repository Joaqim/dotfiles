{
  config,
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
      cpuFlavor = "amd";
      kernelOptimization = true;
    };

    graphics = {
      enable = true;
      gpuFlavor = "amd";
      amd.overdrive.enable = false;
    };
    openrgb.enable = false;
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
