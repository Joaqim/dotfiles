{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      deskreen
      kdenlive
      shotcut
      syncplay # group streaming thingie
      yt-dlp # dependency for syncplay
      ;
  };
}
