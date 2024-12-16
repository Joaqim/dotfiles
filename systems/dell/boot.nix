{
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      grub = {
        enable = true;
        devices = ["/dev/sda"];
      };
      efi.canTouchEfiVariables = true;
    };
    # Allow normal users to use unprivileged namespaces. 'userns' = 'user namespaces'
    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    # Explicitly blacklist unused kernel modules
    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];
  };
}
