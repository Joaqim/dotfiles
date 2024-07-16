{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      virt-manager
      ;
  };
}
