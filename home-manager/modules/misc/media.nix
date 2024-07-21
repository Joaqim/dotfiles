{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      beets
      celluloid
      finamp
      jellycli
      jellyfin
      jellyfin-media-player
      spotify
      stremio
      vlc
      ;
  };
}
