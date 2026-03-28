{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.shell.starship;
in
{
  options.my.home.shell.starship = with lib; {
    enable = mkEnableOption "starship configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[ ∴](bold #8bd5ca)";
          error_symbol = "[ ¬◇](bold #ee99a0)";
        };
      };
    };
  };
}
