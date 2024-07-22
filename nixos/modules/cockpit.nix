{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Get status of package upgrades in cockpit ui
    packagekit
    # Manage SELinux in cockpit ui
    selinux-python
  ];

  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  services.packagekit = {
    enable = true;
  };
}
