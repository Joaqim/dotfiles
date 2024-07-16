{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      vesktop
      ;
  };
  xdg.configFile."vesktop/themes/macchiato.theme.css".source = ./macchiato.theme.css;
}
