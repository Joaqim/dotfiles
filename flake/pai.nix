{ self, inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.nix-pai.flakeModules.default
  ];
  perSystem =
    { ... }:
    {
      imports = [
        "${self}/modules/pai"
      ];
    };
}
