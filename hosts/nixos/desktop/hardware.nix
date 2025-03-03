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

  virtualisation = {
    docker = {
      extraOptions = "--storage-opt=zfs.fsname=zpool-${hostName}/local";
      storageDriver = "zfs";
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

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
  };
}
