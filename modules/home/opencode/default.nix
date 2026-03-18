{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.home.opencode;
in
{
  imports = [
    inputs.nix-agent-wire.homeModules.opencode
  ];
  options.my.home.opencode = with lib; {
    enable = mkEnableOption "automatically wire up commands, skills, agents, MCP servers, and rules using `nix-agent-wire`";
    autoWireDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        List of directories containing agents/, commands/, skills/, mcp/ and memory.md.
        All directories are merged, with later directories taking precedence.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      autoWire.dirs = cfg.autoWireDirs;
    };
  };
}
