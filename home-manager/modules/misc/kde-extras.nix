{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs.kdePackages)
      okular
      partitionmanager
      kolourpaint
      ;
  };
}
