{
  inputs,
  self,
  lib,
  ...
}:
let
  default-overlays = import "${self}/overlays";
  additional-overlays = {
    # Expose my expanded library
    lib = _final: _prev: { inherit (self) lib; };

    # Add nix-minecraft overlay
    nix-minecraft = inputs.nix-minecraft.overlays.default;

    # Add steam-shortcuts overlay
    steam-shortcuts = inputs.steam-shortcuts.overlays.default;

    pkgs = _final: prev: {
      # Provide scoped `pkgs.jqpkgs`
      jqpkgs = lib.recurseIntoAttrs (
        inputs.jqpkgs.overlays.default null # _final remains unused
          prev
      );

      # Expose my custom packages
      my = lib.recurseIntoAttrs (
        import "${self}/pkgs" {
          inherit self;
          pkgs = prev;
          flake-inputs = inputs;
        }
      );
      # Polyfill pkgs.recurseIntoAttrs for when it's not accessed from lib
      inherit (lib) recurseIntoAttrs;
    };
  };
in
{
  flake.overlays = default-overlays // additional-overlays;
}
