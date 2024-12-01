{
  lib,
  pkgs,
  config,
  ...
}: let
  gpuUsbDriverId = "0000:02:00.2"; # lspci -nnv -D     find the gpu related id not managed by vfio
  gpuPCIid1 = "0000:01:00.0";
  gpuPCIid2 = "0000:01:00.1";
in {
  imports = [
    ./boot.nix
    ./filesystem.nix
    #./graphics.nix
    ./impermanence.nix
    ./networking.nix
    ./ssh.nix
  ];
  networking = {
    hostName = "node";
    hostId = "deadbeef";
  };


  services = {
    udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';
    openssh.settings = {
      PermitRootLogin = "yes";
      X11Forwarding = true;
      X11UseLocalhost = true;
    };
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
    };
    spice-vdagentd.enable = true;
  };

  systemd.services = {
    # When booting into emergency or rescue targets, do not require the password
    # of the root user to start a root shell.  I am ok with the security
    # consequences, for this host.  Do not blindly copy this without
    # understanding.  Note that SYSTEMD_SULOGIN_FORCE is considered semi-unstable
    emergency.environment.SYSTEMD_SULOGIN_FORCE = "1";
    rescue.environment.SYSTEMD_SULOGIN_FORCE = "1";

    undervolt = {
      enable = true;
      description = "undervolt";
      # unitConfig = {
      # };
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.undervolt}/bin/undervolt --core -70 --cache -70";
      };
    };
    /*
    forceRebindNVUSB = {
      # patch code unbind and bind use vfio
      enable = true;
      description = "forceRebindNvUsb";
      wantedBy = ["multi-user.target"];
      script = ''
        echo -n "${gpuUsbDriverId}" > /sys/bus/pci/drivers/xhci_hcd/unbind
        echo -n "${gpuUsbDriverId}" > /sys/bus/pci/drivers/vfio-pci/bind
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };*/
    fixGPUPass = {
      enable = true;
      description = "fixGPUPass";
      wantedBy = ["multi-user.target"];
      script = ''
        echo 1 > "/sys/bus/pci/devices/${gpuPCIid1}/remove"
        echo 1 > "/sys/bus/pci/devices/${gpuPCIid2}/remove"
        echo 1 > /sys/bus/pci/rescan
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
  

  users.users.root.extraGroups = ["libvirtd" "libvirt" "kvm"];

  virtualisation = {
    libvirtd = { 
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;

  hardware.xpadneo.enable = true;

  environment = {
    variables = {
      NIXPKGS_ALLOW_INSECURE = "1";
      # Allow Discord ( vesktop )
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-spice
      virtio-win
    ];
  };

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
