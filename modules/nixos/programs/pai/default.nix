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

    environment.systemPackages = [ cfg.package ];
  };
}
