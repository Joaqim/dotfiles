{
  perSystem = {
    pkgs,
    lib,
    config,
    self',
    ...
  }: {
    imports = [
      ./pre-commit.nix
      ./devShells.nix
    ];
  };
}
