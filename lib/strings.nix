# Taken from [1]:
# [1]: https://github.com/ambroisie/nix-config/blob/main/lib/strings.nix
{
  # Make an email address from the name and domain stems
  #
  # mkMailAddress :: String -> String -> String
  mkMailAddress = name: domain: "${name}@${domain}";
}
