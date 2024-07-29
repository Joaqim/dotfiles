{
  pkgs,
  nur,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      grapejuice
      heroic
      lutris
      mangohud
      prismlauncher
      protonup-qt
      steam
      steamtinkerlaunch
      ;
    inherit
      (nur.repos.jpyke3)
      suyu-dev
      ;
  };
}
