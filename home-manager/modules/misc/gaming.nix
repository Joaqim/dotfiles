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
      mangohud
      prismlauncher
      protonup-qt
      steam
      steamtinkerlaunch
      # jc141
      
      dwarfs
      wine-staging
      winetricks
      fuse-overlayfs
      ;
    inherit
      (nur.repos.jpyke3)
      suyu-dev
      ;
  };
}
