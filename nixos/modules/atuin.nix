{
  services.atuin = {
    enable = true;

    # Ensures we only have access through tailscale node, even if the default port `8888` happens to be open.
    host = "0.0.0.0";
    openRegistration = false;
  };
}
