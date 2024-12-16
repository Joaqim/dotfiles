{config, ...}: let
  user = config.home.username;
in {
  home.persistence."/persist/home/${user}" = {
    removePrefixDirectory = true; # for GNU Stow styled dotfile folders
    allowOthers = true;
    directories = [
      "Sunshine/.config/sunshine/credentials"
    ];
    files = [
      "Sunshine/.config/sunshine/sunshine_state.json"
      "Sunshine/.config/sunshine/sunshine.log"
    ];
  };
}
