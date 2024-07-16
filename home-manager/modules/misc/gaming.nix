{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      heroic
      lutris
      prismlauncher
      steam
      grapejuice
      ;
  };
}
