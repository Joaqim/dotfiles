{
  lib,
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
      };
      apps = import "${self}/apps" {
        inherit
          lib
          pkgs
          inputs'
          self
          ;
      };
    };
}
