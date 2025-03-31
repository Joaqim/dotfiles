{
  lib,
  self,
  ...
}: {
  perSystem = {
    self',
    inputs',
    pkgs,
    ...
  }: {
    apps = import "${self}/apps" {
      inherit lib pkgs self' inputs';
    };
  };
}
