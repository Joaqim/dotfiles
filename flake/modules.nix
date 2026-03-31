{
  self,
  ...
}:
{
  # NixOS module exports - category-level imports without 'my.' prefix
  flake.nixosModules = {
    # Import all NixOS modules as a set
    default = import "${self.outPath}/modules/nixos";

    # Category-level exports - import specific categories
    profiles = import "${self.outPath}/modules/nixos/profiles";
    programs = import "${self.outPath}/modules/nixos/programs";
    services = import "${self.outPath}/modules/nixos/services";
    hardware = import "${self.outPath}/modules/nixos/hardware";
    system = import "${self.outPath}/modules/nixos/system";
    secrets = import "${self.outPath}/modules/nixos/secrets";
    home = import "${self.outPath}/modules/nixos/home";
  };

  # Home-manager module exports - category-level imports
  flake.homeManagerModules = {
    # Import all home modules as a set
    default = import "${self.outPath}/modules/home";

    # Category-level exports
    applications = import "${self.outPath}/modules/home/applications";
    desktop = import "${self.outPath}/modules/home/desktop";
    development = import "${self.outPath}/modules/home/development";
    gaming = import "${self.outPath}/modules/home/gaming";
    media = import "${self.outPath}/modules/home/media";
    services = import "${self.outPath}/modules/home/services";
    shell = import "${self.outPath}/modules/home/shell";
    system = import "${self.outPath}/modules/home/system";
    utilities = import "${self.outPath}/modules/home/utilities";
  };
}
