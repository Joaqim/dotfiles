{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.programs.steam;

  inherit (pkgs) protonup-qt steam steamtinkerlaunch;
in {
  options.my.programs.steam = with lib; {
    enable = mkEnableOption "steam configuration";

    dataDir = mkOption {
      type = types.str;
      default = "$HOME";
      example = "/mnt/steam/";
      description = ''
        Which directory should be used as HOME to run steam.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          steam-play-none
          proton-ge-bin
        ];
      };

      # Allows for other packages to depend on steam ( lutris )
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
        ];
    }
    # TODO: Make sure this works;
    # should we explicitly make the original `pkgs` available in environment as well?
    (lib.mkIf (cfg.dataDir != "$HOME") {
      environment.systemPackages = builtins.map lib.hiPrio [
        # Respect XDG conventions, leave my HOME alone
        (pkgs.writeShellScriptBin "steam" ''
          mkdir -p "${cfg.dataDir}"
          HOME="${cfg.dataDir}" exec ${lib.getExe steam} "$@"
        '')
        # Same, for GOG and other such games
        (pkgs.writeShellScriptBin "steam-run" ''
          mkdir -p "${cfg.dataDir}"
          HOME="${cfg.dataDir}" exec ${lib.getExe steam.run}  "$@"
        '')
        (pkgs.writeShellScriptBin "steamtinkerlaunch" ''
          mkdir -p "${cfg.dataDir}"
          HOME="${cfg.dataDir}" exec ${lib.getExe steamtinkerlaunch}  "$@"
        '')
        (pkgs.writeShellScriptBin "protonup-qt" ''
          mkdir -p "${cfg.dataDir}"
          HOME="${cfg.dataDir}" exec ${lib.getExe protonup-qt}  "$@"
        '')
      ];
    })
  ]);
}
