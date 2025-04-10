{
  steamtinkerlaunch,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "create-shortcuts-to-start";
  text = builtins.readFile ./${name}.sh;

  runtimeInputs = builtins.attrValues {
    steamtinkerlaunch =
      steamtinkerlaunch.overrideAttrs
      {
        patches = [./onsteamdeck-envvar.patch];
      };
  };

  meta.description = "";
}
