{
  inputs,
  self,
  ...
}:
let
  default-overlays = import "${self}/overlays";

  additional-overlays = {
    # Expose my expanded library
    lib = _final: _prev: { inherit (self) lib; };

    # Expose my custom packages
    pkgs = _final: prev: {
      jqpkgs = prev.recurseIntoAttrs (
        import "${self}/pkgs" {
          inherit self;
          pkgs = prev;
          flake-inputs = inputs;
        }
      );
    };
  };
in
{
  flake.overlays = default-overlays // additional-overlays;
}
