{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.terminal;
in
{
  config = lib.mkIf (cfg.program == "kitty") {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;

        wayland_enable_ime = true;
      };
    };
  };
}
