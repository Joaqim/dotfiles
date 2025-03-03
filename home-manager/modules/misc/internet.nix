{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      element-desktop
      vesktop
      xdg-utils
      fluent-reader # RSS Reader
      ;
  };
}
