{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "soulseekqt"
    ];
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      exiftool
      kid3
      mp3gain
      nicotine-plus
      puddletag
      soulseekqt
      jellyfin-mpv-shim
      ;
  };
}
