{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      brave
      caprine-bin
      discord
      google-chrome
      element-desktop
      signal-desktop
      vesktop
      xdg-utils
      ;
  };
}
