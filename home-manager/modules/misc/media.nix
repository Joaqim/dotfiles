{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs.nur.repos.nltch)
      spotify-adblock
      ;
  };
}
