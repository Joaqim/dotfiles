{
  inputs',
  pkgs,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "commit-selfup";
  text = builtins.readFile ./${name}.sh;
  runtimeInputs = [
    inputs'.selfup.packages.default
    pkgs.coreutils
    pkgs.gitMinimal
  ];
}
