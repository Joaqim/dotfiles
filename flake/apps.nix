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
      inherit lib pkgs inputs' self;
      flake-inputs = inputs;
    };
  };
}
