{pkgs, ...}: {
  programs.corectrl = {
    enable = true;
    package = pkgs.corectrl;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };
}
