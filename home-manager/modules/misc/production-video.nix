{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      deskreen
      kdenlive
      shotcut
      syncplay # group streaming thingie
      ;
  };
}
