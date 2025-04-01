{
  lib,
  self,
  ...
}: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    apps = import "${self}/apps" {
      inherit lib pkgs inputs';
    };
  };
}
