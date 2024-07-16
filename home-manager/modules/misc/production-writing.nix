{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      libreoffice
      obsidian
      ;
  };
}
