{
  pkgs,
  flake,
  ...
}: {
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
    nexusmods-app = pkgs.nexusmods-app.override {
      _7zz = pkgs._7zz-rar;
    };

    inherit (flake.inputs.self.packages.${pkgs.system}) undertaker141;
  };
}
