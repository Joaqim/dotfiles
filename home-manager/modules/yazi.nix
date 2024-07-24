{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      exiftool
      nomacs
      tokei
      mediainfo
      ;
  };
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    keymap.manager.prepend_keymap = [
      {
        run = "quit";
        on = ["Q"];
      }
      {
        run = "quit --no-cwd-file";
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
            run = "exiftool \"$1\" | $PAGER";
            block = true;
            desc = "Show EXIF";
            for = "unix";
          }
        ];
        open = [
          {
            run = "nomacs \"$@\"";
            desc = "Nomacs";
            orphan = true;
            for = "unix";
          }
          {
            run = "code \"$@\"";
            desc = "VSCode";
            orphan = true;
            for = "unix";
          }
          {
            run = "firefox \"$@\"";
            desc = "Firefox";
            orphan = true;
            for = "unix";
          }
          {
            run = "krita \"$@\"";
            desc = "Krita";
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = "wezterm -e hx \"$@\"";
            desc = "Helix";
            orphan = true;
            for = "unix";
          }
          {
            run = "code \"$@\"";
            desc = "VSCode";
            orphan = true;
            for = "unix";
          }
          {
            run = "tokei \"$1\" | $PAGER";
            block = true;
            desc = "Count Lines";
            for = "unix";
          }
        ];
        play = [
          {
            run = "celluloid \"$@\"";
            desc = "MPV";
            orphan = true;
            for = "unix";
          }
          {
            run = "vlc \"$@\"";
            desc = "VLC";
            orphan = true;
            for = "unix";
          }
          {
            run = "mediainfo \"$1\" | $PAGER";
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

