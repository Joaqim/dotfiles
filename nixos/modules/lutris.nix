{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      lutris.override {
        /*
           extraLibraries = pkgs: [
          # List library dependencies here
        ];
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
        */
      }
    )
  ];
}
