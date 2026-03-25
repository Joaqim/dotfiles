{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.home.claude-code;
in
{

  imports = with inputs; [
    nix-agent-wire.homeModules.claude-code
    alexandria.homeModules.default
  ];

  options.my.home.claude-code = with lib; {
    enable = mkEnableOption "Claude Code configuration";
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
    home.packages = with pkgs; [
      tree
      ollama
    ];
    programs.claude-code = {
      enable = true;

      package = pkgs.claude-code;

      autoWire.dirs = cfg.autoWireDirs;
    };
    # Mostly for providing ~/.config/mcp/
    programs.alexandria = {
      enable = true;
      # Enable MCP explicitly; should be enabled by default
      enableMcpIntegration = true;
    };
  };
}
