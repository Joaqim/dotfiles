{
  coreutils,
  gnutar,
  ripgrep,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "archive-home-files";
  text = builtins.readFile ./${name}.bash;
  runtimeInputs = [
    gnutar
    ripgrep
    coreutils
  ];
  meta.description = "Take a snapshot of current home-manager files in home";
}
