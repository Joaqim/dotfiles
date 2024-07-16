{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      alsa-scarlett-gui
      ardour
      drumgizmo
      yabridge
      ;
  };
}
