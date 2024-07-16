{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      emote
      nomacs
      grim
      slurp
      wl-clipboard
      wpaperd
      ;
  };
}
