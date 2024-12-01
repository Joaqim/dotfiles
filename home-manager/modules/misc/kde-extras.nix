{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs.kdePackages)
      partitionmanager
      kolourpaint
      ;
  };
}
