{pkgs, ...}: let
  catppuccin = pkgs.catppuccin.overrideAttrs ({installPhase, ...}: {
    installPhase = builtins.replaceStrings ["qt5ct/themes/Catppuccin-"] ["qt5ct/themes/catppuccin-"] installPhase;
  });
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      catppuccin-gtk
      openrgb
      ;
    inherit catppuccin;
  };
}
