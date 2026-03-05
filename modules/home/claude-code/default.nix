{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) AI;
  cfg = config.my.home.claude-code;
in
{

  imports = [
    "${AI}/nix/home-manager-module.nix"
  ];

  options.my.home.claude-code = with lib; {
    enable = mkEnableOption "Claude Code configuration";
  };

  # Importing AI home manager module without setting
  config = {
    # Packages often used by Claude Code CLI
    # GitHub and Code specific packages are included with landrunModules, see /apps/landrun-apps/claude-sandboxed
    home.packages = with pkgs; [
      tree
    ];
    programs.claude-code = {
      inherit (cfg) enable;

      #package = inputs.claude-sandbox.packages.${pkgs.stdenv.hostPlatform.system}.claude;
      package = pkgs.claude-code;

      autoWire.dir = AI;
    };
  };
}
