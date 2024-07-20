{pkgs, ...}: {
  hardware = {
    # opengl = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        rocmPackages.clr.icd
        pkgs.amdvlk
      ];
      extraPackages32 = [
        pkgs.driversi686Linux.amdvlk
      ];
    };
  };
  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelParams = ["video=card1-DP-3:3440x1440@100"];
  };
}
