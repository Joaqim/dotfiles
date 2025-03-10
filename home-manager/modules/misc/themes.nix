{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      catppuccin-gtk
      catppuccin
      openrgb
      ;
  };
}
