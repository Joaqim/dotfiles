{
  inputs',
  writeShellApplication,
  git,
  mktemp,
  ...
}:
writeShellApplication {
  name = "commit-nvfetcher";

  runtimeInputs = [
    inputs'.nvfetcher.packages.default
    git
    mktemp
  ];

  text = builtins.readFile ./commit-nvfetcher.sh;
}
