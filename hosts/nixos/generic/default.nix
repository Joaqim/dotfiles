{lib, ...}: {
  my.user = {
    name = "runner";
    fullName = "Github Action Runner";
  };

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
