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
  ];

  options.my.home.claude-code = with lib; {
    enable = mkEnableOption "Claude Code configuration";
    autoWireDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = with inputs; [ AI ];
      description = ''
        List of directories containing agents/, commands/, skills/, mcp/ and memory.md.
        All directories are merged, with later directories taking precedence.
      '';
    };
  };

  # Importing AI home manager module without setting
  config = {
    # Packages often used by Claude Code CLI
    # GitHub and Code specific packages are included with landrunModules, see /apps/landrun-apps/claude-sandboxed
    home.packages = with pkgs; [
      tree
      ollama
    ];
    programs.claude-code = {
      inherit (cfg) enable;

      #package = inputs.claude-sandbox.packages.${pkgs.stdenv.hostPlatform.system}.claude;
      package = pkgs.claude-code;

      autoWire.dirs = cfg.autoWireDirs;
    };
  };
}
