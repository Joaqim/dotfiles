{
  home.file."Documents/.stignore".text = ''
    node_modules
    .direnv
    .next
    /Backups
    /Misc
  '';
  home.file.".local/share/PrismLauncher/.stignore".text = ''
    /prismlauncher.cfg
    /instances/*/instance.cfg
    /accounts.json
    /instances/*/.minecraft/saves
    /instances/*/.minecraft/logs
    /instances/*/minecraft/saves
    /instances/*/minecraft/logs

    /logs
    /cache
    /instances~
  '';
}
