Submodules in ./apps/<application-name> is expected to return path to application executable as string.

Will become:
`perSystem.${system}.apps.<application-name>` = {
    type = "app";
    program = "/nix/store/<path-to-executable>"
};

# TODO:
```
Improve importing shell scripts by automating import of <application-name>/<script>.sh with `writeShellApplication`
```

```nix
writeShellApplication {
    name = "<application-name>";
    text = builtins.readFile <script>.sh;
}
```