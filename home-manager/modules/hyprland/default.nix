{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    settings = {
      animation = import ./config/animation.nix;
      bezier = import ./config/bezier.nix;
      bind = import ./config/bind.nix;
      bindm = import ./config/bindm.nix;
      binds = import ./config/binds.nix;
      decoration = import ./config/decoration.nix;
      dwindle = import ./config/dwindle.nix;
      exec-once = import ./config/exec-once-desktop.nix;
      general = import ./config/general.nix;
      input = import ./config/input.nix;
      misc = import ./config/misc.nix;
      windowrule = import ./config/windowrule.nix;
      windowrulev2 = import ./config/windowrulev2.nix;
    };
    # plugins = [
    #   flake.inputs.hycov.packages.${pkgs.system}.hycov
    # ];
    # extraConfig = ''
    #   bind=ALT,tab,hycov:toggleoverview

    #   plugin {
    #       hycov {
    #         enable_hotarea = 0
    #         overview_gappo = 80 #gaps width from screen
    #         overview_gappi = 10 #gaps width from clients
    #       }
    #   }
    # '';
  };
  xdg.configFile."wpaperd/wallpaper.toml".source = pkgs.lib.mkForce ./wpaperd/wallpaper.toml;
}
