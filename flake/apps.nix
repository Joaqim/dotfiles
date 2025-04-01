{
  lib,
  self,
  inputs,
  ...
}: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    apps = import "${self}/apps" {
      inherit lib pkgs inputs';
      flake-inputs = inputs;
    };
  };
}
