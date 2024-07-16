{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      catppuccin
      catppuccin-gtk
      openrgb
      ;
  };
}
