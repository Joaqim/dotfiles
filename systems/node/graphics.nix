{pkgs, ...}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
      ];
      extraPackages32 = [
        pkgs.driversi686Linux.amdvlk
      ];
    };
  };
  boot = {
    initrd.kernelModules = ["amdgpu"];
  };
}
