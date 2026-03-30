self: {
  # NixOS module exports - category-level imports without 'my.' prefix
  flake.nixosModules = {
    # Import all NixOS modules as a set
    default = "${self}/modules/nixos";

    # Category-level exports - import specific categories
    profiles = "${self}/modules/nixos/profiles";
    programs = "${self}/modules/nixos/programs";
    services = "${self}/modules/nixos/services";
    hardware = "${self}/modules/nixos/hardware";
    system = "${self}/modules/nixos/system";
    secrets = "${self}/modules/nixos/secrets";
    home = "${self}/modules/nixos/home";
  };

  # Home-manager module exports - category-level imports
  flake.homeManagerModules = {
    # Import all home modules as a set
    default = "${self}/modules/home";

    # Category-level exports
    applications = "${self}/modules/home/applications";
    desktop = "${self}/modules/home/desktop";
    development = "${self}/modules/home/development";
    gaming = "${self}/modules/home/gaming";
    media = "${self}/modules/home/media";
    services = "${self}/modules/home/services";
    shell = "${self}/modules/home/shell";
    system = "${self}/modules/home/system";
    utilities = "${self}/modules/home/utilities";
  };
}
