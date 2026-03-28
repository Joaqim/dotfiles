{ pkgs, ... }:
{
  my.home.system = {
    documentation.enable = false;
    jq.enable = false;
    packages.additionalPackages = builtins.attrValues {
      inherit (pkgs)
        # TODO: Is this still needed?
        # KDE complains, even if nvidia doesn't seem to provide power profiles ?
        power-profiles-daemon
        discord
        ;
      inherit (pkgs.nur.repos.nltch)
        spotify-adblock
        ;
    };
    secrets.enable = false; # Disable for now
  };
}
