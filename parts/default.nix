{
  perSystem = {
    pkgs,
    lib,
    config,
    self',
    ...
  }: {
    imports = [
      ./devshells.nix
      ./pre-commit.nix
    ];
  };
}
