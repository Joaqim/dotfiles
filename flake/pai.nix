{ self, inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.nix-pai.flakeModules.default
  ];
  perSystem = _: {
    _module.args.flakeInputs = inputs;
    imports = [
      "${self}/modules/pai"
    ];
  };
}
