let
  superBinds = builtins.map (x: "SUPER, " + x) [
    "mouse:272, resizewindow"
  ];

  altBinds = builtins.map (x: "ALT, " + x) [
    "mouse:272, movewindow"
  ];
in
  superBinds ++ altBinds
