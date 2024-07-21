{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      bitwarden
      firejail
      homebank
      protonvpn-gui
      ;
  };
}
