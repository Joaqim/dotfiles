{ writeShellApplication, ... }:
writeShellApplication {
  name = "commit-flake-lock";
  text = ''
    nix flake update --commit-lock-file --option commit-lockfile-summary "bump(flake): flake.lock: Update flake inputs"
  '';
  meta.description = "Use nix to update flake inputs in `./flake.lock` with commitizen formatted commit";
}
