{writeShellApplication, ...}:
writeShellApplication {
  name = "commit-flake-lock";
  text = ''
    nix flake update --commit-lock-file --option commit-lockfile-summary "bump(flake): flake.lock: Update flake inputs"
  '';
}
