# {pkgs, ...}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    # extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
