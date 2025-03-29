# [1]: https://github.com/kachick/dotfiles/blob/main/scripts/dry.bash
{lib, ...}: {
  perSystem = {
    self',
    inputs',
    ...
  }: {
    apps = let
      inherit (inputs'.nixpkgs.legacyPackages) writeShellScript;
      commit-nvfetcher = lib.getExe self'.packages.commit-nvfetcher;
      home-manager = lib.getExe inputs'.home-manager.packages.home-manager;

      mkApp = program: {
        inherit program;
        type = "app";
      };
    in {
      commit-nvfetcher = mkApp (toString (
        writeShellScript "commit-nvfetcher" ''
          ${commit-nvfetcher} -k /tmp/github-key.toml
        ''
      ));

      home-manager = mkApp home-manager;
      dry-activate = mkApp (toString (
        # [1]:
        writeShellScript "dry-activate"
        ''
          set -exo pipefail

          if [ -f '/etc/NIXOS' ]; then
          	# Prefer `build` rather than `test` and `dry-reactivate` for the speed and not requiring root permissions
          	nixos-rebuild build --flake ".#$(hostname)" --show-trace
          fi

          _HOME_CONF=".#$USER"
          if [ ! -z "$HM_HOST_SLUG" ]; then
            _HOME_CONF+="@$HOSTNAME"
          fi

          nix run '.#home-manager' -- switch --dry-run -b backup --show-trace --flake $_HOME_CONF
        ''
      ));

      default = self'.apps.commit-nvfetcher;
    };
  };
}
