{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.terminal;
in
{
  config = lib.mkIf (cfg.program == "kitty") {
    programs.kitty = {
      enable = true;
    };
  };
}
