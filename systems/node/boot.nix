{
  lib,
  pkgs,
  config,
  flake,
  ...
}: let
  inherit (flake.config) people;
  userName = people.users.${people.user0}.name;

  gpuIDs = [
    "1002:67b0" # Graphics
    "1002:aac8" # Audio
    "1d6b:0003" # usb 3.0
  ];
in {
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];

    supportedFilesystems = ["zfs"];
    initrd = {
      network.openvpn.enable = true;
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "sd_mod"];
      kernelModules = [ ];
    };
    blacklistedKernelModules = [ "radeon" "amdgpu" "snd_hda_intel"];
    extraModprobeConfig = lib.mkAfter ''
      softdep amdgpu pre: vfio-cpi
      softdep radeon pre: vfio-pci
    '';
    kernelModules = [
      "kvm-intel"

      "v4l2loopback"
      "msr"
      "vfio_pci"
      "vfio_virqfd"
      "vfio_iommu_type1"
      "vfio"
    ];
    kernelParams = [
      "nohibernate"
      "init_on_alloc=0"
      "zfs.zfs_arc_sys_free=${toString (1024 * 1024 * 1024 * 24)}"
      "hugepagesz=2G"
      "hugepages=1"
      "console=tty1"
      "intel_iommu=on"
      "iommu=pt"
      "video=vesafb:off"
      "video=efifb:off"
      "video=simplefb:off"
      "nofb"
      "nomodeset"
      "vga=normal"
      "textonly" 
      "i915.modeset=0"
      ("vfio-pci.ids=" + builtins.concatStringsSep "," gpuIDs)
    ];
 
    zfs = {
      extraPools = ["zroot"];
    };

    loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      generationsDir = {
        copyKernels = true;
      };

      grub = {
        enable = true;
        copyKernels = true;
        device = "nodev";
        efiSupport = true;
        zfsSupport = true;

        # Enable while transferring systems between different machines, also toggle `efi.canTouchEfiVariables` to false
        # https://mynixos.com/nixpkgs/option/boot.loader.grub.efiInstallAsRemovable
        efiInstallAsRemovable = true;

        theme = pkgs.sleek-grub-theme.override {
          withBanner = "Welcome, ${userName}!";
          withStyle = "bigSur";
        };
      };
    };
  };
}
