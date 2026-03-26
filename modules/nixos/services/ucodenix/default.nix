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
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc ''
        CPU model ID for microcode updates.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ucodenix = lib.mkMerge [
      { enable = true; }
      (lib.mkIf (cfg.cpuModelId != null) {
        inherit (cfg) cpuModelId;
      })
    ];
  };
}
