{
  steamtinkerlaunch,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "add-non-steam-game";
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
