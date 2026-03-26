{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.services.ucodenix;
in
{
  imports = [
    inputs.ucodenix.nixosModules.default
  ];

  options.my.services.ucodenix = {
    enable = lib.mkEnableOption "ucodenix CPU microcode updates";

    cpuModelId = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        CPU model ID for microcode updates.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ucodenix = {
      enable = true;
      inherit (cfg) cpuModelId;
    };
  };
}
