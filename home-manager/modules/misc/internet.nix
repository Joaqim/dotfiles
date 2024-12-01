{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      brave
      discord
      google-chrome
      element-desktop
      vesktop
      xdg-utils
      ;
  };
}
