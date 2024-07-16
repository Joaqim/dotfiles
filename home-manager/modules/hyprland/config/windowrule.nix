let
  centerWindows = [
    "center, ^(gnome-characters)$"
    "center, ^(celluloid)$"
    "center, ^(nomacs)$"
    "center, ^(stremio)$"
  ];
  opaqueWindows = builtins.map (x: "opaque, " + x) [
    "^(firefox)$"
    "^(gimp)$"
    "^(kdenlive)$"
    "^(krita)$"
    "^(celluloid)$"
    "^(stremio)$"
  ];
in
  centerWindows ++ opaqueWindows
