{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    keymap.manager.prepend_keymap = [
      {
        exec = "quit";
        on = ["Q"];
      }
      {
        exec = "quit --no-cwd-file";
        on = ["q"];
      }
    ];

    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_dir_first = true;
        sort_reverse = false;
      };
      preview = {
        tab_size = 2;
        max_width = 1500;
        max_height = 1000;
      };
      opener = {
        reveal = [
          {
            exec = "exiftool \"$1\" | $PAGER";
            block = true;
            desc = "Show EXIF";
            for = "unix";
          }
        ];
        open = [
          {
            exec = "nomacs \"$@\"";
            desc = "Nomacs";
            orphan = true;
            for = "unix";
          }
          {
            exec = "code \"$@\"";
            desc = "VSCode";
            orphan = true;
            for = "unix";
          }
          {
            exec = "firefox \"$@\"";
            desc = "Firefox";
            orphan = true;
            for = "unix";
          }
          {
            exec = "krita \"$@\"";
            desc = "Krita";
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            exec = "wezterm -e hx \"$@\"";
            desc = "Helix";
            orphan = true;
            for = "unix";
          }
          {
            exec = "code \"$@\"";
            desc = "VSCode";
            orphan = true;
            for = "unix";
          }
          {
            exec = "tokei \"$1\" | $PAGER";
            block = true;
            desc = "Count Lines";
            for = "unix";
          }
        ];
        play = [
          {
            exec = "celluloid \"$@\"";
            desc = "MPV";
            orphan = true;
            for = "unix";
          }
          {
            exec = "vlc \"$@\"";
            desc = "VLC";
            orphan = true;
            for = "unix";
          }
          {
            exec = "mediainfo \"$1\" | $PAGER";
            block = true;
            desc = "Media Info";
            for = "unix";
          }
        ];
      };
    };
  };
}
# Keymap
# https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/keymap.toml

