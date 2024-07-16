{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      exiftool
      kid3
      mp3gain
      nicotine-plus
      puddletag
      soulseekqt
      ;
  };
}
