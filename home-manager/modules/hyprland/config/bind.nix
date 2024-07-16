let
  superBinds = builtins.map (x: "SUPER, " + x) [
    # Apps
    "Space, exec, rm -r /home/$USER/.cache/tofi* ; tofi-drun"
    "7, exec, /home/$USER/dotfiles/home-manager/modules/hyprland/config/scripts/workspace1.sh"
    "8, exec, /home/$USER/dotfiles/home-manager/modules/hyprland/config/scripts/workspace2.sh"
    "T, exec, /home/$USER/dotfiles/home-manager/modules/hyprland/config/scripts/terminal.sh"
    "G, exec, /home/$USER/dotfiles/home-manager/modules/hyprland/config/scripts/yazi.sh"
    "V, exec, code /home/$USER/dotfiles/"
    "C, exec, code"
    "S, exec, obsidian"
    "E, exec, nautilus"
    "O, exec, obs"
    "B, exec, firefox"
    "D, exec, discord"
    "L, exec, lutris"
    "W, exec, bitwarden"
    "R, exec, gnome-system-monitor"
    "N, exec, signal-desktop"
    "M, exec, element-desktop"
    "K, exec, kdenlive"
    "P, exec, spotify"
    "A, exec, steam"
    "H, exec, scrcpy"
    "End, exec, hyprctl dispatch exit"
    "period, exec, emote"
    "comma, exec, gnome-characters"
    # Workspaces
    "1, workspace, 1"
    "2, workspace, 2"
    "3, workspace, 3"
    "4, workspace, 4"
    "5, workspace, 5"
    # Windows
    "F, togglefloating"
    "X, killactive"
    "Tab, fullscreen, 0"
    "P, pin, enable"
    "bracketleft, splitratio, -0.1"
    "bracketright, splitratio, +0.1"
    # Window Focus
    "left , movefocus, l"
    "down , movefocus, d"
    "up , movefocus, u"
    "right , movefocus, r"
    # Audio
    "F8, exec, playerctl next"
    "F7, exec, playerctl previous"
    "F6, exec, playerctl play-pause"
  ];

  superShiftBinds = builtins.map (x: "SUPER SHIFT, " + x) [
    # Super+shift binds
    "S, exec, grim -g \"$(slurp)\" - | wl-copy -t image/png"
    "Print, exec, grim -g \"$(slurp)\""
    "ScrollDown, workspace, previous"
    "left , movewindow, l"
    "down , movewindow, d"
    "up , movewindow, u"
    "right , movewindow, r"
  ];
  superCtrlBinds = builtins.map (x: "SUPER CTRL, " + x) [
    # Super+shift binds
    "Space, workspace, previous"
    "S, layoutmsg, togglesplit"
    "X, splitratio, 0.33"
    "Z, splitratio, -0.33"
  ];

  altBinds = builtins.map (x: "ALT, " + x) [
    # Alt binds
  ];

  shiftBinds = builtins.map (x: "SHIFT, " + x) [
    # Shift binds
  ];

  ctrlBinds = builtins.map (x: "CTRL, " + x) [
    # Ctrl binds
  ];

  ctrlShiftBinds = builtins.map (x: "CTRL SHIFT, " + x) [
    # Ctrl+shift binds
    "1, movetoworkspacesilent, 1"
    "2, movetoworkspacesilent, 2"
    "3, movetoworkspacesilent, 3"
    "4, movetoworkspacesilent, 4"
  ];
in
  superBinds ++ superShiftBinds ++ superCtrlBinds ++ altBinds ++ ctrlBinds ++ ctrlShiftBinds ++ shiftBinds
# Docs
# https://wiki.hyprland.org/Getting-Started/Master-Tutorial/

