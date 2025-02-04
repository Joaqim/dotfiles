{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib.fileset) toSource gitTracked;

  PLASMOID_HOME_DESTINATION_PATH = ".local/share/plasma/plasmoids/com.github.configurable_button";
  # `systemctl` commands without sudo enabled by `doas` configuration in: ./../../../nixos/modules/doas.nix
  configurable-button = let
    plasmoid-button = pkgs.fetchFromGitHub {
      owner = "pmarki";
      repo = "plasmoid-button";
      rev = "a7106b2fd055ff551d66381df526254d0f3719b6";
      hash = "sha256-MoI7CDtG9OOO8g+t4Zf9lF59RVbKWFnjfbsVwD0m47U=";
    };
    icons = toSource {
      root = ./.;
      fileset = gitTracked ./icons;
    };
  in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "configurable_button";
      version = "1.0.0";
      srcs = [
        plasmoid-button
        icons
      ];
      phases = ["installPhase"];
      installPhase = ''
        mkdir -p $out
        cp -r ${plasmoid-button}/* $out/
        cp -r ${icons}/* $out/
        runHook postInstall
      '';

      postInstall = ''
        substituteInPlace $out/contents/config/main.xml \
          --replace-fail emblem-error "$out/icons/minecraft-server-icon-64x64_offline.png" \
          --replace-fail emblem-checked "$out/icons/minecraft-server-icon-64x64_online.png" \
          --replace-fail "sleep 2; exit 0" "systemctl start docker-minecraft-vault-hunters" \
          --replace-fail "sleep 1; exit 0" "systemctl stop docker-minecraft-vault-hunters" \
          --replace-fail "/bin/status_script.sh" "systemctl is-active --quiet docker-minecraft-vault-hunters"
      '';
    };
in {
  home.file."${PLASMOID_HOME_DESTINATION_PATH}".source = mkOutOfStoreSymlink configurable-button;
}
