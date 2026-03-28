{ writeShellApplication, ... }:
writeShellApplication rec {
  name = "test-changes";
  text = builtins.readFile ./${name}.sh;
  meta.description = "Incremental flake testing - only evaluate changed modules";
}
