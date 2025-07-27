_self: prev: {
  steamtinkerlaunch = prev.steamtinkerlaunch.overrideAttrs {
    patches = [ ./onsteamdeck-envvar.patch ];
  };
}
