self: _prev: {
  fluent-reader = self.pkgs.my.fluent-reader-from-src.overrideAttrs {
    patches = [ ./open-magnet-links.patch ];
  };
}
