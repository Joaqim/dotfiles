{nur, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (nur.repos.nltch)
      spotify-adblock
      ;
  };
}
