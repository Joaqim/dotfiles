{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      gimp
      krita
      opentabletdriver
      ;
  };
}
