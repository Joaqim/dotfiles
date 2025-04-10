{
  inputs',
  writeShellApplication,
  gitMinimal,
  mktemp,
  ...
}:
writeShellApplication rec {
  name = "commit-nvfetcher";
  text = builtins.readFile ./${name}.sh;

  runtimeInputs = [
    inputs'.nvfetcher.packages.default
    gitMinimal
    mktemp
  ];

  meta.description = "Use `nvfetcher` to update sources in `./pkgs/sources.nix` with commitizen formatted commit";
}
