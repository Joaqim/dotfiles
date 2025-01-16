{pkgs, ...}: {
  home.packages = builtins.attrValues {
    cataclysm-dda-git = pkgs.cataclysm-dda-git.override {
      version = "0.H-RELEASE"; # 2024-10-24
      rev = "08f04fd07f028219a65f2f1fc8e73719dc9c954e";
    };
  };
}
