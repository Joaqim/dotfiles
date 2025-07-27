{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      packages =
        let
          inherit (inputs.flake-utils.lib) filterPackages flattenTree;
          packages = import "${self}/pkgs" {
            inherit pkgs self;
            flake-inputs = inputs;
          };
          flattenedPackages = flattenTree packages;
          finalPackages = filterPackages system flattenedPackages;
        in
        finalPackages;
    };
}
