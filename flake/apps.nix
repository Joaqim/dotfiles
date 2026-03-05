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

        # NOTE: This applies to everything, not just apps
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "claude-code"
          ];

      };
      apps = import "${self}/apps" {
        inherit
          lib
          pkgs
          inputs'
          self
          system
          ;
      };
    };
}
