Submodules in ./apps/<application-name> is expected to return path to application executable as string.

Will become:
`perSystem.${system}.apps.<application-name>` = {
    type = "app";
    program = "/nix/store/<path-to-executable>"
};

# TODO:
```
Improve importing shell scripts by automating import of <application-name>/<script>.sh with `writeShellScript`
```

```nix
toString (
    writeShellScript "<application-name>" builtins.readFile <script>.sh
)
```