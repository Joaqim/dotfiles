{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      bitwarden
      firejail
      homebank
      ledger-live-desktop
      protonvpn-gui
      ;
  };
}
