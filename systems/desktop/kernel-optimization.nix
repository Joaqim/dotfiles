{
  # https://github.com/tolgaerok/nixos-kde?tab=readme-ov-file#enhancing-user-experience-through-kernel-optimization
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1; # SysRQ for is rebooting their machine properly if it freezes: SOURCE: https://oglo.dev/tutorials/sysrq/index.html
    "net.core.rmem_default" = 16777216; # Default socket receive buffer size, improve network performance & applications that use sockets
    "net.core.rmem_max" = 16777216; # Maximum socket receive buffer size, determin the amount of data that can be buffered in memory for network operations
    "net.core.wmem_default" = 16777216; # Default socket send buffer size, improve network performance & applications that use sockets
    "net.core.wmem_max" = 16777216; # Maximum socket send buffer size, determin the amount of data that can be buffered in memory for network operations
    "net.ipv4.tcp_keepalive_intvl" = 30; # TCP keepalive interval between probes, TCP keepalive probes, which are used to detect if a connection is still alive.
    "net.ipv4.tcp_keepalive_probes" = 5; # TCP keepalive probes, TCP keepalive probes, which are used to detect if a connection is still alive.
    "net.ipv4.tcp_keepalive_time" = 300; # TCP keepalive interval (seconds), TCP keepalive probes, which are used to detect if a connection is still alive.
    "vm.dirty_background_bytes" = 268435456; # 256 MB in bytes, data that has been modified in memory and needs to be written to disk
    "vm.dirty_bytes" = 1073741824; # 1 GB in bytes, data that has been modified in memory and needs to be written to disk
    "vm.min_free_kbytes" = 65536; # Minimum free memory for safety (in KB), can help prevent memory exhaustion situations
    "vm.swappiness" = 1; # how aggressively the kernel swaps data from RAM to disk. Lower values prioritize keeping data in RAM,
    "vm.vfs_cache_pressure" = 50; # Adjust vfs_cache_pressure (0-1000), how the kernel reclaims memory used for caching filesystem objects
  };
}
