Submodules in ./apps/<application-name> is expected to return path to application executable as string.

Will become:
`perSystem.${system}.apps.<application-name>` = {
    type = "app";
    program = "/nix/store/<path-to-executable>"
};