{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      desktop-file-utils
      exiftool
      mediainfo
      ;
  };
}
