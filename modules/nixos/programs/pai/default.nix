{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.programs.pai;
  # Access the PAI package from the flake's perSystem packages
  inherit (pkgs.stdenv.hostPlatform) system;
  paiPackage = inputs.self.packages.${system}.pai or null;
in
{
  options.my.programs.pai = with lib; {
    enable = mkEnableOption "Personal AI Assistant (PAI)";
    package = lib.mkOption {
      type = lib.types.package;
      default = paiPackage;
      defaultText = lib.literalExpression "pai.packages.\${pkgs.stdenv.hostPlatform.system}.default";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package != null;
        message = "PAI package not found for system ${system}. Make sure the pai flakeModule is properly configured.";
      }
    ];
    # NOTE: This is mostly just to ensure that Neovim plugin uses our wrapped claude instance
    # see /modules/home/nvf/default.nix
    environment.systemPackages = [
      (cfg.package.overrideAttrs (prev: {
        # Don't add claude to environment
        # We will instead use alias to our `pai` package
        buildInputs = builtins.filter (pkg: (lib.getName pkg) != "claude") prev.buildInputs;
      }))
    ]
    ++ map lib.hiPrio [
      (pkgs.writeShellScriptBin "claude" ''
        # Simple hack to auto-magically prompt azure authentication instead of anthropic when using /login
        # Maybe also utilize ANTHROPIC_FOUNDRY_RESOURCE for figuring out which default subscription to use ?
        if [ "$CLAUDE_CODE_USE_FOUNDRY" = "1" ] && [ "$1" = "/login" ]; then
          ${lib.getExe pkgs.azure-cli} login
          exit "$?"
        fi
        exec ${lib.getExe cfg.package} "$@"
      '')
    ];
  };
}
