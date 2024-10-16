{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      heroic
      mangohud
      prismlauncher
      protonup-qt
      steam
      steamtinkerlaunch
      ;
  };
}
