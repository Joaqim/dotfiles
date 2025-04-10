{
  coreutils,
  inputs',
  gitMinimal,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "commit-selfup";
  text = builtins.readFile ./${name}.sh;
  runtimeInputs = [
    coreutils
    gitMinimal
    inputs'.selfup.packages.default
  ];

  meta.description = "Use `selfup` to update CI dependencies in .github/workflows with commitizen formatted commit";
}
