{
  pkgs,
  lib,
  flake,
  ...
}: let
  inherit (flake.inputs.json2steamshortcut.packages.${pkgs.system}) json2steamshortcut;
  toTOML = name: data: (pkgs.formats.toml {}).generate name data;
  # Declare our shortcuts natively in our nix configuration
  json = builtins.toJSON [
    {
      AppName = "Firefox";
      Exe = "firefox";
      StartDir = lib.getExe' pkgs.firefox "";
      AllowOverlay = false;
    }
    {
      AppName = "Ghost of Tsushima";
      LaunchOptions = "lutris:rungame/ghost-of-tsushima";
      Exe = "lutris";
      StartDir = lib.getExe' pkgs.lutris "";
      Icon = "/home/jq/.local/share/icons/hicolor/128x128/apps/lutris_ghost-of-tsushima.png";

      AllowOverlay = false;
      Tags = ["Lutris" "Ready TO Play" "Installed"];
    }
  ];
  # Create the vdf file at build time
  vdf = pkgs.runCommand "shortcuts.vdf" {
    nativeBuildInputs = [json2steamshortcut];
  } "echo '${json}' | json2steamshortcut > $out";
in {
  # use home-manager to place our shortcuts.vdf at the correct location (this is user and steam account specific)
  home.file.".local/share/Steam/userdata/44453327/config/shortcuts.vdf".source = vdf;

  # Boilr Configuration
  home.file.".config/boilr/config.toml".source = toTOML "boilr-config.toml" (lib.mergeAttrs (builtins.fromTOML (builtins.readFile ./boilr-config.toml)) {steamgrid_db.auth_key = "secret";});

  # Run Boilr on startup to create Icons and Banners in Steam
  systemd.user.services.boilr = {
    Unit = {
      Description = "Run Boilr to automatically add artwork to non-Steam shortcuts.";
      After = ["NetworkManager.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.boilr} --no-ui";
      Restart = "on-failure";
      Type = "oneshot";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
