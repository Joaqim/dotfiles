{writeShellApplication, ...}:
writeShellApplication {
  name = "update-flake-inputs";
  text = ''
    nix flake update --commit-lock-file --option commit-lockfile-summary "chore(deps): Update flake inputs"
  '';
}
