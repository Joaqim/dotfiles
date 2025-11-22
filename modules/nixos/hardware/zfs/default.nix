{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.zfs;
  # https://wiki.nixos.org/wiki/ZFS#Selecting_the_latest_ZFS-compatible_Kernel
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );

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
    boot = {
      # Note this might jump back and forth as kernels are added or removed.
      kernelPackages = lib.mkForce latestKernelPackage;
      supportedFilesystems = [ "zfs" ];
      loader.grub.zfsSupport = lib.mkDefault true;
    };
  };
}
