{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      tofi
      ;
  };
  xdg.configFile = {"tofi/config".source = ./config;};
}
