{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      android-file-transfer
      android-tools
      scrcpy
      ;
  };
}
#requires that users be part of the adbusers group

