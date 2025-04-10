{
  coreutils,
  dwarfs,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "extract-dwarfs";
  text = builtins.readFile ./${name}.sh;

  runtimeInputs = [
    coreutils
    dwarfs
  ];

  meta.description = "";
}
