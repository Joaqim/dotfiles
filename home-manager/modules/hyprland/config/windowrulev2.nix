let
  maxsizeWindows = [
    "maxsize 640x360, class:^(blueman-manager)$"
    "maxsize 960x540, class:^(gnome-characters)$"
    "maxsize 960x540, class:^(celluloid)$"
    "maxsize 960x540, class:^(nomacs)$"
    "maxsize 960x540, class:^(stremio)$"
  ];
  floatWindows = builtins.map (x: "float, " + x) [
    "class:(blueman-manager)"
    "class:(easyeffects)"
    "class:(emote)"
    "class:(gnome-characters)"
    "class:(celluloid)"
    "class:(nomacs)"
    "class:(stremio)"
    "title:^(Picture-in-Picture)$"
  ];

  pinWindows = builtins.map (x: "pin, " + x) [
    "title:^(Picture-in-Picture)$"
  ];
in
  maxsizeWindows ++ floatWindows ++ pinWindows
