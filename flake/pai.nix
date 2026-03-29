{ self, inputs, ... }:
{
  imports = [
    inputs.nix-pai.flakeModules.default
  ];
  perSystem = _: {
    _module.args.flakeInputs = inputs;
    imports = [
      "${self}/modules/pai"
    ];
  };
}
