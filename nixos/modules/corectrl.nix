{pkgs, ...}: {
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
            action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("wheel")) {
                return polkit.Result.YES;
        }
    });
  '';

  environment.systemPackages = [
    (pkgs.makeAutostartItem rec {
      name = "corectl";
      package = pkgs.makeDesktopItem {
        inherit name;
        desktopName = "CoreCtrl";
        exec = "corectrl --minimize-systray";
        icon = "corectrl";
      };
    })
  ];
}
