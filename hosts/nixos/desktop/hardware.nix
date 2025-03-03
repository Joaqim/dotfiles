{
  config,
  modulesPath,
  ...
}: let
  inherit (config.networking) hostName;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/persist".neededForBoot = true;

  my.hardware = {
    firmware = {
      cpuFlavor = "amd";
      kernelOptimization = true;
    };

    graphics = {
      enable = true;
      gpuFlavor = "amd";
      amd.amdvlk = true;
    };
    # Use zfs specific settings for docker virtualization and zfs trim and scrub
    zfs = {
      enable = true;
      zfsDataset = "zpool-${hostName}/local";
    };
  };
}
