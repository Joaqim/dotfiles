{
  pkgs,
  nur,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      beets
      celluloid
      finamp
      jellycli
      jellyfin
      jellyfin-media-player
      stremio
      vlc
      ;
    inherit
      (nur.repos.nltch)
      spotify-adblock
      ;
  };
}
