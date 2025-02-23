{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      discord
      element-desktop
      vesktop
      xdg-utils
      fluent-reader # RSS Reader
      ;
  };
}
