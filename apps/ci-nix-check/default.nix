{
  coreutils,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "ci-nix-check";
  text = builtins.readFile ./${name}.sh;
  runtimeInputs = [
    coreutils
  ];

  meta.description = "Run nix flake check and evaluate available 'x86-64-linux' NixOS configurations";
}
